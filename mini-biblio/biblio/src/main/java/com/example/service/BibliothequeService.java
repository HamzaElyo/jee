package com.example.service;


import com.example.repository.LivreRepository;
import jakarta.inject.Inject;
import jakarta.enterprise.context.Dependent;
import com.example.model.Livre;

@Dependent
public class BibliothequeService {

    @Inject
    private LivreRepository livreRepo;

    public void afficherLivre(long id) {
        Livre livre = livreRepo.trouverParId(id);
        System.out.println("📚 Livre trouvé : " + livre);
    }
}
