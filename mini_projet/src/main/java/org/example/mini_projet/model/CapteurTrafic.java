package org.example.mini_projet.model;

import jakarta.persistence.*;

import java.util.List;

@Entity
public class CapteurTrafic {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String nom;
    private String type;
    private String localisation;
    private String zone;

    @OneToMany(mappedBy = "capteur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    List <MesureTrafic> mesures;

    // Getters et setters
    public Long getId() { return id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    public String getLocalisation() { return localisation; }
    public void setLocalisation(String localisation) { this.localisation = localisation; }
    public String getZone() { return zone; }
    public void setZone(String zone) { this.zone = zone; }

    public List<MesureTrafic> getMesures() {
        return mesures;
    }

    public void setMesures(List<MesureTrafic> mesures) {
        this.mesures = mesures;
    }
}