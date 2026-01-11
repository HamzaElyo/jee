package com.example.model;

public class Livre {
    private long id;
    private String titre;

    public Livre(long id, String titre) {
        this.id = id;
        this.titre = titre;
    }

    public long getId() { return id; }
    public String getTitre() { return titre; }

    @Override
    public String toString() {
        return "[" + id + "] " + titre;
    }
}
