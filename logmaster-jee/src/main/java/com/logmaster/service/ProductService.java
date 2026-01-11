package com.logmaster.service;

import com.logmaster.dao.ProductDAO;
import com.logmaster.entity.Product;
import jakarta.ejb.EJB;
import jakarta.ejb.Stateless;
import java.util.List;

@Stateless
public class ProductService {

    @EJB
    private ProductDAO productDAO;

    public void createProduct(Product product) {
        productDAO.create(product);
    }

    public void updateProduct(Product product) {
        productDAO.update(product);
    }

    public void deleteProduct(Long id) {
        productDAO.delete(id);
    }

    public Product getProductById(Long id) {
        return productDAO.findById(id);
    }

    public List<Product> getAllProducts() {
        return productDAO.findAll();
    }
}
