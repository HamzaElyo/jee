package org.example.energie.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class ReleveConsommation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime dateHeure;
    private double valeur;
    private String unite;

    @ManyToOne
    private CompteurIntelligent compteur;

    // Getters/Setters...
    public Long getId() { return id; }
    public LocalDateTime getDateHeure() { return dateHeure; }
    public void setDateHeure(LocalDateTime dateHeure) { this.dateHeure = dateHeure; }
    public double getValeur() { return valeur; }
    public void setValeur(double valeur) { this.valeur = valeur; }
    public String getUnite() { return unite; }
    public void setUnite(String unite) { this.unite = unite; }
    public CompteurIntelligent getCompteur() { return compteur; }
    public void setCompteur(CompteurIntelligent compteur) { this.compteur = compteur; }
}
