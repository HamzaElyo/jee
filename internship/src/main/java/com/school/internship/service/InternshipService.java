package com.school.internship.service;

import com.school.internship.dao.CompanyDAO;
import com.school.internship.dao.InternshipDAO;
import com.school.internship.dao.StudentDAO;
import com.school.internship.entity.Company;
import com.school.internship.entity.Internship;
import com.school.internship.entity.Student;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
@Transactional
public class InternshipService {

    @Inject
    private InternshipDAO internshipDAO;

    @Inject
    private StudentDAO studentDAO;

    @Inject
    private CompanyDAO companyDAO;

    public Internship createInternship(Internship internship, Long studentId, Long companyId) {
        // Validation dates
        if (internship.getEndDate().isBefore(internship.getStartDate())) {
            throw new IllegalArgumentException("La date de fin doit être après la date de début");
        }

        Student student = studentDAO.findById(studentId)
                .orElseThrow(() -> new IllegalArgumentException("Étudiant introuvable"));

        Company company = companyDAO.findById(companyId)
                .orElseThrow(() -> new IllegalArgumentException("Entreprise introuvable"));

        internship.setStudent(student);
        internship.setCompany(company);

        return internshipDAO.save(internship);
    }

    public Optional<Internship> getInternshipById(Long id) {
        return internshipDAO.findById(id);
    }

    public List<Internship> getAllInternships() {
        return internshipDAO.findAll();
    }

    public List<Internship> getInternshipsByStudent(Long studentId) {
        return internshipDAO.findByStudentId(studentId);
    }

    public Internship updateInternship(Long id, Internship updated) {
        Internship existing = internshipDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Stage introuvable"));

        existing.setTitle(updated.getTitle());
        existing.setStartDate(updated.getStartDate());
        existing.setEndDate(updated.getEndDate());
        existing.setDescription(updated.getDescription());

        return internshipDAO.save(existing);
    }

    public void deleteInternship(Long id) {
        internshipDAO.deleteById(id);
    }
}