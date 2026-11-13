@echo off
echo === Setting up Git repository for github.com/subham18nath ===
if not exist .git (
    git init
)
git branch -M main
git remote remove origin 2>nul
git remote add origin https://github.com/subham18nath/ecommerce-sales-analysis.git
git add .
git commit -m "feat: complete e-commerce sales analysis portfolio project (SQL, Excel, Power BI)"
echo.
echo Make sure you have created the empty repo 'ecommerce-sales-analysis' on github.com/subham18nath!
git push -u origin main
pause
