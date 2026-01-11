package com.bankflow.model;

public enum TypeCompte {
    COMPTE_COURANT("Compte Courant"),
    COMPTE_EPARGNE("Compte Épargne"),
    COMPTE_JOINT("Compte Joint"),
    COMPTE_ENTREPRISE("Compte Entreprise");

    private final String libelle;

    TypeCompte(String libelle) {
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