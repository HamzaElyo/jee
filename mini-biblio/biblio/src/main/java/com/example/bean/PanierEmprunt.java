package com.example.bean;

import com.example.model.Livre;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.context.SessionScoped;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@ApplicationScoped
public class PanierEmprunt implements Serializable {
    private List<Livre> livres = new ArrayList<>();

    public void ajouterLivre(Livre livre) {
        livres.add(livre);
    }

    public void afficherPanier() {
        System.out.println("🛒 Panier : " + livres);
    }
}
