package com.bankflow.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "comptes")
public class Compte {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_compte", unique = true, nullable = false)
    private String numeroCompte;

    @Enumerated(EnumType.STRING)
    @Column(name = "type_compte")
    private TypeCompte type;

    private BigDecimal solde = BigDecimal.ZERO;

    @Column(name = "decouvert_autorise")
    private BigDecimal decouvertAutorise = BigDecimal.ZERO;

    @Column(name = "taux_interet")
    private BigDecimal tauxInteret = BigDecimal.ZERO;

    private String devise = "EUR";

    private Boolean actif = true;

    @Column(name = "date_creation")
    private LocalDateTime dateCreation;

    @Column(name = "date_modification")
    private LocalDateTime dateModification;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "client_id")
    private Client client;

    @OneToMany(mappedBy = "compte", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Transaction> transactions;

    // Constructeurs
    public Compte() {
        this.dateCreation = LocalDateTime.now();
        this.dateModification = LocalDateTime.now();
    }

    public Compte(String numeroCompte, TypeCompte type, Client client) {
        this();
        this.numeroCompte = numeroCompte;
        this.type = type;
        this.client = client;
    }

    // Getters et setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNumeroCompte() { return numeroCompte; }
    public void setNumeroCompte(String numeroCompte) { this.numeroCompte = numeroCompte; }

    public TypeCompte getType() { return type; }
    public void setType(TypeCompte type) { this.type = type; }

    public BigDecimal getSolde() { return solde; }
    public void setSolde(BigDecimal solde) { this.solde = solde; }

    public BigDecimal getDecouvertAutorise() { return decouvertAutorise; }
    public void setDecouvertAutorise(BigDecimal decouvertAutorise) { this.decouvertAutorise = decouvertAutorise; }

    public BigDecimal getTauxInteret() { return tauxInteret; }
    public void setTauxInteret(BigDecimal tauxInteret) { this.tauxInteret = tauxInteret; }

    public String getDevise() { return devise; }
    public void setDevise(String devise) { this.devise = devise; }

    public Boolean getActif() { return actif; }
    public void setActif(Boolean actif) { this.actif = actif; }

    public LocalDateTime getDateCreation() { return dateCreation; }
    public void setDateCreation(LocalDateTime dateCreation) { this.dateCreation = dateCreation; }

    public LocalDateTime getDateModification() { return dateModification; }
    public void setDateModification(LocalDateTime dateModification) { this.dateModification = dateModification; }

    public Client getClient() { return client; }
    public void setClient(Client client) { this.client = client; }

    public List<Transaction> getTransactions() { return transactions; }
    public void setTransactions(List<Transaction> transactions) { this.transactions = transactions; }

    // Méthode utilitaire
    public String getTypeLibelle() {
        return type != null ? type.getLibelle() : "Non spécifié";
    }
}