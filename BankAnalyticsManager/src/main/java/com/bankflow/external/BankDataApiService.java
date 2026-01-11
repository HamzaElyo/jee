// src/main/java/com/bankflow/external/BankDataApiService.java
package com.bankflow.external;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

public class BankDataApiService {

    public ExternalFinancialData fetchMarketData() {
        System.out.println("🔄 Tentative de récupération des données marché...");

        // Essayer Frankfurter en premier
        ExternalFinancialData data = tryFrankfurterAPI();
        if (data != null) return data;

        // Essayer ExchangeRate-API en second
        data = tryExchangeRateAPI();
        if (data != null) return data;

        // Fallback sur données simulées
        System.out.println("❌ Toutes les APIs ont échoué, utilisation des données simulées");
        return simulateMarketData();
    }

    private ExternalFinancialData tryFrankfurterAPI() {
        try {
            URL url = new URL("https://api.frankfurter.app/latest?from=EUR&to=USD");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(3000);
            conn.setReadTimeout(3000);

            if (conn.getResponseCode() == 200) {
                Scanner scanner = new Scanner(conn.getInputStream());
                StringBuilder response = new StringBuilder();
                while (scanner.hasNextLine()) {
                    response.append(scanner.nextLine());
                }
                scanner.close();
                conn.disconnect();

                return parseJsonResponse(response.toString(), "USD");
            }
            conn.disconnect();
        } catch (Exception e) {
            System.err.println("Frankfurter API error: " + e.getMessage());
        }
        return null;
    }

    private ExternalFinancialData tryExchangeRateAPI() {
        try {
            URL url = new URL("https://api.exchangerate-api.com/v4/latest/EUR");
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setConnectTimeout(3000);

            if (conn.getResponseCode() == 200) {
                Scanner scanner = new Scanner(conn.getInputStream());
                StringBuilder response = new StringBuilder();
                while (scanner.hasNextLine()) {
                    response.append(scanner.nextLine());
                }
                scanner.close();
                conn.disconnect();

                return parseJsonResponse(response.toString(), "USD");
            }
            conn.disconnect();
        } catch (Exception e) {
            System.err.println("ExchangeRate-API error: " + e.getMessage());
        }
        return null;
    }

    private ExternalFinancialData parseJsonResponse(String json, String targetCurrency) {
        try {
            // Chercher le taux de la devise cible
            String searchStr = "\"" + targetCurrency + "\":";
            int index = json.indexOf(searchStr);
            if (index != -1) {
                int start = index + searchStr.length();
                int end = json.indexOf(",", start);
                if (end == -1) end = json.indexOf("}", start);

                String rateStr = json.substring(start, end).trim();
                double rate = Double.parseDouble(rateStr);

                ExternalFinancialData data = new ExternalFinancialData();
                data.setEurUsdRate(Math.round(rate * 10000.0) / 10000.0);
                data.setMarketVolatility(calculateVolatility(rate));
                data.setMarketTrend(determineTrend(rate));

                System.out.println("✅ Données réelles obtenues - EUR/" + targetCurrency + ": " + rate);
                return data;
            }
        } catch (Exception e) {
            System.err.println("Parse error: " + e.getMessage());
        }
        return null;
    }

    private double calculateVolatility(double rate) {
        return Math.round((1.8 + Math.abs(rate - 1.08) * 30) * 100.0) / 100.0;
    }

    private String determineTrend(double rate) {
        if (rate > 1.085) return "HAUSSE";
        if (rate < 1.075) return "BAISSE";
        return "STABLE";
    }

    private ExternalFinancialData simulateMarketData() {
        ExternalFinancialData data = new ExternalFinancialData();
        double rate = 1.07 + (Math.random() * 0.04);
        data.setEurUsdRate(Math.round(rate * 10000.0) / 10000.0);
        data.setMarketVolatility(Math.round((1.5 + Math.random() * 3.0) * 100.0) / 100.0);
        data.setMarketTrend(determineTrend(rate));
        return data;
    }
}