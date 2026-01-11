package org.example.mini_projet.dao;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
public class JpaUtil {
    private static final EntityManagerFactory emf =
            Persistence.createEntityManagerFactory("jee_project");
    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    public static void close() {
        emf.close();
    }
}