package com.example;

import org.jboss.weld.environment.se.Weld;
import org.jboss.weld.environment.se.WeldContainer;

import com.example.service.BibliothequeService;
import com.example.bean.PanierEmprunt;
import com.example.model.Livre;

public class App {
    public static void main(String[] args) {
        Weld weld = new Weld();
        try (WeldContainer container = weld.initialize()) {
            BibliothequeService service = container.select(BibliothequeService.class).get();
            PanierEmprunt panier = container.select(PanierEmprunt.class).get();

            service.afficherLivre(1);
            panier.ajouterLivre(new Livre(2, "Design Patterns"));
            panier.afficherPanier();
        }
    }
}
