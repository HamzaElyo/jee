// src/main/java/com/bankflow/external/ExternalFinancialData.java
package com.bankflow.external;

import java.util.Date;

public class ExternalFinancialData {
    private Double eurUsdRate;
    private Double marketVolatility;
    private Date lastUpdate;
    private String marketTrend;


    public ExternalFinancialData() {
        this.lastUpdate = new Date();
    }

    // Getters et Setters
    public Double getEurUsdRate() { return eurUsdRate; }
    public void setEurUsdRate(Double eurUsdRate) { this.eurUsdRate = eurUsdRate; }

    public Double getMarketVolatility() { return marketVolatility; }
    public void setMarketVolatility(Double marketVolatility) { this.marketVolatility = marketVolatility; }

    public Date getLastUpdate() { return lastUpdate; }
    public void setLastUpdate(Date lastUpdate) { this.lastUpdate = lastUpdate; }

    public String getMarketTrend() { return marketTrend; }
    public void setMarketTrend(String marketTrend) { this.marketTrend = marketTrend; }
}
