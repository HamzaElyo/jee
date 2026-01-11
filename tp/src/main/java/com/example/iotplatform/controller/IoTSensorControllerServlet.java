package com.example.iotplatform.controller;

import com.example.iotplatform.model.SensorReading;
import com.example.iotplatform.service.IoTSensorManagerService;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

/**
 * Servlet contrôleur pour le tableau de bord IoT.
 * Permet d’afficher et d’ajouter des lectures de capteurs.
 */
@WebServlet("/iot-dashboard")
public class IoTSensorControllerServlet extends HttpServlet {

    @Inject
    private IoTSensorManagerService iotSensorManagerService;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupération des lectures existantes via le service
        List<SensorReading> readingList = iotSensorManagerService.retrieveAllSensorReadings();

        // Ajout de la liste à la requête pour affichage dans la JSP
        request.setAttribute("readings", readingList);

        // Redirection vers la vue JSP
        request.getRequestDispatcher("/WEB-INF/views/iot-dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Récupération des paramètres du formulaire
        String sensorId = request.getParameter("sensorId");
        String sensorType = request.getParameter("sensorType");
        String value = request.getParameter("value");
        String unit = request.getParameter("unit");
        String location = request.getParameter("location");

        // Création d’un nouvel objet SensorReading
        SensorReading newReading = new SensorReading(
                UUID.randomUUID().toString(),  // readingId unique
                sensorId,
                sensorType,
                Double.parseDouble(value),
                unit,
                System.currentTimeMillis(),    // timestamp
                location
        );

        // Envoi de la lecture au service
        iotSensorManagerService.ingestSensorReading(newReading);

        // Redirection vers la page du tableau de bord
        response.sendRedirect(request.getContextPath() + "/iot-dashboard");
    }
}
