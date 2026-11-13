#!/bin/bash
# E-commerce Sales Analysis - Quick Push Script for Subham Nath
echo "=== Setting up Git repository for github.com/subham18nath ==="

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    git init
    echo "Initialized empty Git repository."
fi

git branch -M main

# Add remote if not already added
if git remote | grep -q 'origin'; then
    echo "Remote origin already exists. Updating URL..."
    git remote set-url origin https://github.com/subham18nath/ecommerce-sales-analysis.git
else
    git remote add origin https://github.com/subham18nath/ecommerce-sales-analysis.git
fi

git add .
git commit -m "feat: complete e-commerce sales analysis portfolio project (SQL, Excel, Power BI)"
echo ""
echo "=== Ready to push! ==="
echo "Make sure you created an empty repo named 'ecommerce-sales-analysis' on your GitHub."
echo "Running: git push -u origin main"
git push -u origin main
