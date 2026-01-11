package com.elearning.connector.loader;

import com.elearning.connector.config.ApiConfig;
import com.elearning.connector.model.LearningEvent;
import com.elearning.connector.model.Student;
import com.opencsv.CSVReader;
import com.opencsv.CSVReaderBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.FileReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Chargeur de données OULAD (Open University Learning Analytics Dataset)
 */
public class OuladDataLoader {
    
    private static final Logger logger = LoggerFactory.getLogger(OuladDataLoader.class);
    private Map<Integer, String> vleActivityTypes = new HashMap<>();

    /**
     * Charge les types d'activités depuis vle.csv
     */
    public void loadVleTypes(String vlePath) {
        try (Reader reader = new FileReader(vlePath);
             CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(1).build()) {
            
            String[] row;
            while ((row = csvReader.readNext()) != null) {
                if (row.length >= 3) {
                    int siteId = Integer.parseInt(row[0]);
                    String activityType = row[2]; // activity_type column
                    vleActivityTypes.put(siteId, activityType);
                }
            }
            
            logger.info("Loaded {} VLE activity types", vleActivityTypes.size());
            
        } catch (Exception e) {
            logger.error("Error loading VLE types", e);
        }
    }

    /**
     * Charge les étudiants depuis studentInfo.csv
     */
    public List<Student> loadStudents(String filePath) {
        List<Student> students = new ArrayList<>();
        
        try (Reader reader = new FileReader(filePath);
             CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(1).build()) {
            
            String[] row;
            while ((row = csvReader.readNext()) != null) {
                if (row.length >= 12) {
                    Student student = new Student();
                    student.setCodeModule(row[0]);
                    student.setCodePresentation(row[1]);
                    student.setStudentId("student_" + row[2]);
                    student.setGender(row[3]);
                    student.setRegion(row[4]);
                    student.setHighestEducation(row[5]);
                    student.setAgeBand(row[7]);
                    student.setDisability(row[10]);
                    student.setFinalResult(row[11]);
                    
                    students.add(student);
                }
            }
            
            logger.info("Loaded {} students from OULAD", students.size());
            
        } catch (Exception e) {
            logger.error("Error loading students", e);
        }
        
        return students;
    }

    /**
     * Charge les événements d'apprentissage depuis studentVle.csv
     * Note: Ce fichier est très volumineux (10M+ lignes), on utilise le batch processing
     */
    public List<LearningEvent> loadEvents(String filePath, int limit) {
        List<LearningEvent> events = new ArrayList<>();
        
        try (Reader reader = new FileReader(filePath);
             CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(1).build()) {
            
            String[] row;
            int count = 0;
            
            while ((row = csvReader.readNext()) != null && count < limit) {
                if (row.length >= 6) {
                    LearningEvent event = new LearningEvent();
                    event.setCodeModule(row[0]);
                    event.setCodePresentation(row[1]);
                    event.setStudentId("student_" + row[2]);
                    event.setSiteId(Integer.parseInt(row[3]));
                    event.setDate(Integer.parseInt(row[4]));
                    event.setSumClick(Integer.parseInt(row[5]));
                    
                    // Map activity type from VLE
                    String activityType = vleActivityTypes.getOrDefault(event.getSiteId(), "resource");
                    event.setActivityType(activityType);
                    
                    events.add(event);
                    count++;
                }
            }
            
            logger.info("Loaded {} learning events from OULAD", events.size());
            
        } catch (Exception e) {
            logger.error("Error loading events", e);
        }
        
        return events;
    }

    /**
     * Charge les événements par batch pour éviter les problèmes de mémoire
     */
    public void loadEventsInBatches(String filePath, BatchProcessor processor) {
        try (Reader reader = new FileReader(filePath);
             CSVReader csvReader = new CSVReaderBuilder(reader).withSkipLines(1).build()) {
            
            List<LearningEvent> batch = new ArrayList<>(ApiConfig.BATCH_SIZE);
            String[] row;
            int totalProcessed = 0;
            
            while ((row = csvReader.readNext()) != null) {
                if (row.length >= 6) {
                    LearningEvent event = new LearningEvent();
                    event.setCodeModule(row[0]);
                    event.setCodePresentation(row[1]);
                    event.setStudentId("student_" + row[2]);
                    event.setSiteId(Integer.parseInt(row[3]));
                    event.setDate(Integer.parseInt(row[4]));
                    event.setSumClick(Integer.parseInt(row[5]));
                    
                    String activityType = vleActivityTypes.getOrDefault(event.getSiteId(), "resource");
                    event.setActivityType(activityType);
                    
                    batch.add(event);
                    
                    if (batch.size() >= ApiConfig.BATCH_SIZE) {
                        processor.processBatch(batch);
                        totalProcessed += batch.size();
                        batch.clear();
                        
                        if (totalProcessed % 100000 == 0) {
                            logger.info("Processed {} events...", totalProcessed);
                        }
                    }
                }
            }
            
            // Process remaining
            if (!batch.isEmpty()) {
                processor.processBatch(batch);
                totalProcessed += batch.size();
            }
            
            logger.info("Total events processed: {}", totalProcessed);
            
        } catch (Exception e) {
            logger.error("Error loading events in batches", e);
        }
    }

    @FunctionalInterface
    public interface BatchProcessor {
        void processBatch(List<LearningEvent> events);
    }
}
