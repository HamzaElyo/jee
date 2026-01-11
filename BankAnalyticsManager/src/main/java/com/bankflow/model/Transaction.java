package com.bankflow.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "transactions")
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "date_operation", nullable = false)
    private LocalDateTime dateOperation;

    @Enumerated(EnumType.STRING)
    @Column(name = "type_transaction")
    private TypeTransaction type;

    private BigDecimal montant;

    private String description;

    private String reference;

    private String beneficiaire;

    private String contrepartie;

    private String statut = "EXECUTEE";

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "compte_id")
    private Compte compte;

    // Constructeurs
    public Transaction() {
        this.dateOperation = LocalDateTime.now();
    }

    public Transaction(TypeTransaction type, BigDecimal montant, String description, Compte compte) {
        this();
        this.type = type;
        this.montant = montant;
        this.description = description;
        this.compte = compte;
    }

    // Getters et setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public LocalDateTime getDateOperation() { return dateOperation; }
    public void setDateOperation(LocalDateTime dateOperation) { this.dateOperation = dateOperation; }

    public TypeTransaction getType() { return type; }
    public void setType(TypeTransaction type) { this.type = type; }

    public BigDecimal getMontant() { return montant; }
    public void setMontant(BigDecimal montant) { this.montant = montant; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }

    public String getBeneficiaire() { return beneficiaire; }
    public void setBeneficiaire(String beneficiaire) { this.beneficiaire = beneficiaire; }

    public String getContrepartie() { return contrepartie; }
    public void setContrepartie(String contrepartie) { this.contrepartie = contrepartie; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Compte getCompte() { return compte; }
    public void setCompte(Compte compte) { this.compte = compte; }

    // Méthode utilitaire
    public String getTypeLibelle() {
        return type != null ? type.getLibelle() : "Non spécifié";
    }

    public boolean isCredit() {
        return type == TypeTransaction.DEPOT ||
                type == TypeTransaction.VIREMENT_RECU ||
                type == TypeTransaction.INTERETS ||
                type == TypeTransaction.REMUNERATION;
    }

    public boolean isDebit() {
        return type == TypeTransaction.RETRAIT ||
                type == TypeTransaction.VIREMENT_EMIS ||
                type == TypeTransaction.PRELEVEMENT ||
                type == TypeTransaction.FRAIS;
    }
}