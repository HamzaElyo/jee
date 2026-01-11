package com.bankflow.model;

public enum TypeTransaction {
    DEPOT("Dépôt"),
    RETRAIT("Retrait"),
    VIREMENT_EMIS("Virement émis"),
    VIREMENT_RECU("Virement reçu"),
    PRELEVEMENT("Prélèvement"),
    FRAIS("Frais bancaires"),
    INTERETS("Intérêts"),
    REMUNERATION("Rémunération");

    private final String libelle;

    TypeTransaction(String libelle) {
        this.libelle = libelle;
    }

    public String getLibelle() {
        return libelle;
    }

    @Override
    public String toString() {
        return this.libelle;
    }
}