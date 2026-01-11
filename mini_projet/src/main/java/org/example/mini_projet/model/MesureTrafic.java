package org.example.mini_projet.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class MesureTrafic {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private LocalDateTime dateHeure;
    private int vehicules;
    private double vitesseMoy;
    private double tauxEmbouteillage;
    private String typeVehicule;

    @ManyToOne
    @JoinColumn(name = "capteur_id")
    private CapteurTrafic capteur;

    // Getters et setters

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDateTime getDateHeure() {
        return dateHeure;
    }

    public void setDateHeure(LocalDateTime dateHeure) {
        this.dateHeure = dateHeure;
    }

    public int getVehicules() {
        return vehicules;
    }

    public void setVehicules(int vehicules) {
        this.vehicules = vehicules;
    }

    public double getVitesseMoy() {
        return vitesseMoy;
    }

    public void setVitesseMoy(double vitesseMoy) {
        this.vitesseMoy = vitesseMoy;
    }

    public double getTauxEmbouteillage() {
        return tauxEmbouteillage;
    }

    public void setTauxEmbouteillage(double tauxEmbouteillage) {
        this.tauxEmbouteillage = tauxEmbouteillage;
    }

    public String getTypeVehicule() {
        return typeVehicule;
    }

    public void setTypeVehicule(String typeVehicule) {
        this.typeVehicule = typeVehicule;
    }

    public CapteurTrafic getCapteur() {
        return capteur;
    }

    public void setCapteur(CapteurTrafic capteur) {
        this.capteur = capteur;
    }
}