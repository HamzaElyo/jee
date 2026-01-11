package com.school.internship.service;

import com.school.internship.dao.CompanyDAO;
import com.school.internship.entity.Company;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
@Transactional
public class CompanyService {

    @Inject
    private CompanyDAO companyDAO;

    public Company createCompany(Company company) {
        return companyDAO.save(company);
    }

    public Optional<Company> getCompanyById(Long id) {
        return companyDAO.findById(id);
    }

    public List<Company> getAllCompanies() {
        return companyDAO.findAll();
    }

    public Company updateCompany(Long id, Company updated) {
        Company existing = companyDAO.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Entreprise introuvable"));

        existing.setName(updated.getName());
        existing.setSector(updated.getSector());
        existing.setCity(updated.getCity());

        return companyDAO.save(existing);
    }

    public void deleteCompany(Long id) {
        companyDAO.deleteById(id);
    }
}