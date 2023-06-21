-- 1. Standardize 'SaleDate' Date Format

UPDATE NashvilleHousing
SET SaleDate = CAST(SaleDate AS date); 

-- This query did not work in my case, so an alternative can be used:

ALTER TABLE NashvilleHousing
ADD SaleDateConverted date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(date, SaleDate);

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate;

-- 2. Populate Property Address Data
SELECT *
FROM NashvilleHousing
ORDER BY ParcelID 
-- The query above made us realize that wherever the ParcelID of two rows was the same value, 
-- so was the PropertyAddress. With this in mind, we can populate the null values where the respective ParcelID
-- of another row is the same and its PropertyAddress is populated. We can perform a self-join on the table for that:

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress 
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing a
JOIN NashvilleHousing b
ON a.ParcelID = b.ParcelID AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

-- 3.1 Break out Property Address into individual columns (Address, City)

SELECT PropertyAddress, 
TRIM(SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)) AS Address,
TRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))) AS City
FROM PortfolioProjects..NashvilleHousing
-- I used the query above for testing and separate the address and city information from the PropertyAddress column 
-- using the SUBSTRING function based on what separates them, which is the comma (,).

-- Create a new column to stored the 'city' information and update it:

ALTER TABLE NashvilleHousing
ADD PropertyCity nvarchar(255);

UPDATE PortfolioProjects..NashvilleHousing
SET PropertyCity = TRIM(SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- Update the PropertyAddress column to remove the 'city' information, which is now in another column:

UPDATE PortfolioProjects..NashvilleHousing
SET PropertyAddress = TRIM(SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1))

-- 3.2 Break out Owner Address into individual columns (Address, City, State)

SELECT OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProjects..NashvilleHousing
-- For testing purposes, we can use the PARSENAME function above to separate the three parts we want from the OwnerAddress
-- column into different columns.

-- Add columns and update them using PARSENAME to separate the address information:

ALTER TABLE PortfolioProjects..NashvilleHousing
ADD OwnerCity nvarchar(255), OwnerState nvarchar(255);

UPDATE PortfolioProjects..NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

UPDATE PortfolioProjects..NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

UPDATE PortfolioProjects..NashvilleHousing
SET OwnerAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

-- 4. Change 'Y' and 'N' to 'YES' and 'NO' in 'SoldAsVacant' Column.
SELECT DISTINCT SoldAsVacant
FROM NashvilleHousing
-- With the query above we can verify the distinct entries there are for the column.
-- Update the column separately OR using a CASE statement:

UPDATE NashvilleHousing
SET SoldAsVacant = 'No'
WHERE SoldAsVacant = 'N'

UPDATE NashvilleHousing
SET SoldAsVacant = 'Yes'
WHERE SoldAsVacant = 'Y'

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
					END

-- 5. Remove Duplicates
-- The logic used here is if we have multiple rows where many columns such as 'ParcelID', 'PropertyAddress', 'LegalReference',
-- 'SalePrice', 'SaleDate' have the same value, we can make use of only one and remove the duplicates:

WITH Duplicates_CTE AS (
SELECT ParcelID, PropertyAddress, SalePrice, LegalReference, SaleDateConverted,
ROW_NUMBER() OVER (PARTITION BY ParcelID, PropertyAddress, SalePrice, LegalReference, SaleDateConverted
					ORDER BY UniqueID) Duplicates
FROM PortfolioProjects..NashvilleHousing
)
DELETE FROM Duplicates_CTE
WHERE Duplicates > 1

-- With the query above, we created a CTE from the original table because we needed to spread out all the rows that had
-- duplicate values. Then we were able to delete all duplicate rows.

-- 6. Delete Unused Columns
-- For educational purposes, I selected two columns I thought were the 'least' important so we can see how to delete the
-- ones we do not need.
ALTER TABLE PortfolioProjects..NashvilleHousing
DROP COLUMN TaxDistrict, Acreage;