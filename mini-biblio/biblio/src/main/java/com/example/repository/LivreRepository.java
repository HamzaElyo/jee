package com.example.repository;
import  com.example.model.Livre;

public interface LivreRepository {
        Livre trouverParId(long id);
}
