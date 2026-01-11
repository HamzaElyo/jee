package com.bankflow.service;

import com.bankflow.dao.*;
import com.bankflow.model.*;
import jakarta.persistence.EntityManager;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Random;

public class BankService {
    private ClientDao clientDao = new ClientDao();
    private CompteDao compteDao = new CompteDao();
    private TransactionDao transactionDao = new TransactionDao();

    public void effectuerDepot(Long compteId, BigDecimal montant, String description) {
        if (montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant doit être positif");
        }

        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();

        try {
            Compte compte = em.find(Compte.class, compteId);
            if (compte == null) {
                throw new IllegalArgumentException("Compte non trouvé");
            }

            compte.setSolde(compte.getSolde().add(montant));

            Transaction transaction = new Transaction();
            transaction.setType(TypeTransaction.DEPOT);
            transaction.setMontant(montant);
            transaction.setDescription(description);
            transaction.setCompte(compte);

            em.persist(transaction);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new RuntimeException("Erreur lors du dépôt", e);
        } finally {
            em.close();
        }
    }

    public void effectuerRetrait(Long compteId, BigDecimal montant, String description) {
        if (montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant doit être positif");
        }

        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();

        try {
            Compte compte = em.find(Compte.class, compteId);
            if (compte == null) {
                throw new IllegalArgumentException("Compte non trouvé");
            }

            BigDecimal soldeApresRetrait = compte.getSolde().subtract(montant);

            if (soldeApresRetrait.compareTo(compte.getDecouvertAutorise().negate()) < 0) {
                throw new IllegalArgumentException("Solde insuffisant");
            }

            compte.setSolde(soldeApresRetrait);

            Transaction transaction = new Transaction();
            transaction.setType(TypeTransaction.RETRAIT);
            transaction.setMontant(montant.negate());
            transaction.setDescription(description);
            transaction.setCompte(compte);

            em.persist(transaction);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void effectuerVirement(Long compteSourceId, Long compteDestId, BigDecimal montant, String description) {
        if (montant.compareTo(BigDecimal.ZERO) <= 0) {
            throw new IllegalArgumentException("Le montant doit être positif");
        }

        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();

        try {
            Compte compteSource = em.find(Compte.class, compteSourceId);
            Compte compteDest = em.find(Compte.class, compteDestId);

            if (compteSource == null || compteDest == null) {
                throw new IllegalArgumentException("Compte source ou destination non trouvé");
            }

            // Vérifier le solde
            BigDecimal soldeApresRetrait = compteSource.getSolde().subtract(montant);
            if (soldeApresRetrait.compareTo(compteSource.getDecouvertAutorise().negate()) < 0) {
                throw new IllegalArgumentException("Solde insuffisant pour effectuer le virement");
            }

            // Débiter le compte source
            compteSource.setSolde(soldeApresRetrait);

            // Créditer le compte destination
            compteDest.setSolde(compteDest.getSolde().add(montant));

            // Créer les transactions
            Transaction transactionDebit = new Transaction();
            transactionDebit.setType(TypeTransaction.VIREMENT_EMIS);
            transactionDebit.setMontant(montant.negate());
            transactionDebit.setDescription("Virement vers " + compteDest.getNumeroCompte() + " - " + description);
            transactionDebit.setCompte(compteSource);

            Transaction transactionCredit = new Transaction();
            transactionCredit.setType(TypeTransaction.VIREMENT_RECU);
            transactionCredit.setMontant(montant);
            transactionCredit.setDescription("Virement de " + compteSource.getNumeroCompte() + " - " + description);
            transactionCredit.setCompte(compteDest);

            em.persist(transactionDebit);
            em.persist(transactionCredit);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void genererDonneesTest() {
        EntityManager em = JpaUtil.getEntityManager();
        em.getTransaction().begin();

        try {
            Random random = new Random();

            // Créer des clients
            String[] noms = {"Martin", "Bernard", "Dubois", "Thomas", "Robert", "Richard", "Petit", "Durand", "Leroy", "Moreau"};
            String[] prenoms = {"Jean", "Marie", "Pierre", "Paul", "Jacques", "Anne", "Sophie", "Nicolas", "François", "Isabelle"};

            for (int i = 0; i < 10; i++) {
                Client client = new Client();
                client.setNom(noms[random.nextInt(noms.length)]);
                client.setPrenom(prenoms[random.nextInt(prenoms.length)]);
                client.setEmail(client.getPrenom().toLowerCase() + "." + client.getNom().toLowerCase() + "@email.com");
                client.setNumeroSecuriteSociale("1" + String.format("%02d", i) + " " +
                        String.format("%02d", random.nextInt(12) + 1) + " " +
                        String.format("%02d", random.nextInt(95) + 5) + " " +
                        String.format("%03d", random.nextInt(999) + 1) + " " +
                        String.format("%03d", random.nextInt(999) + 1));
                client.setAdresse(random.nextInt(100) + " Rue de la Banque");
                client.setVille("Paris");
                client.setCodePostal("7500" + random.nextInt(10));

                em.persist(client);

                // Créer des comptes pour chaque client
                for (int j = 0; j < random.nextInt(3) + 1; j++) {
                    Compte compte = new Compte();
                    compte.setNumeroCompte("FR76" + String.format("%011d", random.nextInt(1000000000)));
                    compte.setType(TypeCompte.values()[random.nextInt(TypeCompte.values().length)]);
                    compte.setSolde(BigDecimal.valueOf(random.nextDouble() * 10000));
                    compte.setClient(client);

                    if (compte.getType() == TypeCompte.COMPTE_COURANT) {
                        compte.setDecouvertAutorise(BigDecimal.valueOf(500));
                    }

                    em.persist(compte);

                    // Générer des transactions
                    for (int k = 0; k < random.nextInt(20) + 5; k++) {
                        Transaction transaction = new Transaction();
                        transaction.setType(TypeTransaction.values()[random.nextInt(TypeTransaction.values().length)]);
                        transaction.setMontant(BigDecimal.valueOf(random.nextDouble() * 1000 - 500));
                        transaction.setDescription("Transaction " + (k + 1));
                        transaction.setCompte(compte);
                        transaction.setDateOperation(LocalDateTime.now().minusDays(random.nextInt(90)));

                        em.persist(transaction);
                    }
                }

                if (i % 5 == 0) {
                    em.flush();
                    em.clear();
                }
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw new RuntimeException("Erreur lors de la génération des données de test", e);
        } finally {
            em.close();
        }
    }
}