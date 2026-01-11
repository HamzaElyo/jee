package com.example.repository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import  com.example.model.Livre;

@ApplicationScoped
public class LivreRepositoryImpl implements LivreRepository {
    @Override
    public Livre trouverParId(long id) {
        return new Livre(id, "Introduction à CDI");
    }
}
