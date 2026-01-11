package com.school.internship.dao;

import com.school.internship.entity.Company;
import jakarta.enterprise.context.ApplicationScoped;

@ApplicationScoped
public class CompanyDAO extends GenericDAO<Company> {

    public CompanyDAO() {
        super(Company.class);
    }
}