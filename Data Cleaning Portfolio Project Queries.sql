/*
Cleaning Data in SQL Queries
*/

SELECT *
FROM portfolioproject.nashville_housing;


--------------------------------------------------------------------------------------------------------------------------
-- Standardize Date Format

ALTER TABLE nashville_housing
MODIFY COLUMN SaleDate DATE;


--------------------------------------------------------------------------------------------------------------------------
-- Populate Property Address data

SELECT *
FROM nashville_housing
-- WHERE PropertyAddress = '' OR char_length(PropertyAddress) = 1
ORDER BY ParcelID;


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, IFNULL(b.PropertyAddress, a.PropertyAddress) AS UpdatedAddress
FROM nashville_housing a
JOIN nashville_housing b 
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
WHERE a.PropertyAddress = '' OR CHAR_LENGTH(a.PropertyAddress) = 1;


UPDATE nashville_housing a
JOIN nashville_housing b 
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
SET a.PropertyAddress = IFNULL(b.PropertyAddress, a.PropertyAddress)
WHERE a.PropertyAddress = '' OR CHAR_LENGTH(a.PropertyAddress) = 1;


--------------------------------------------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM nashville_housing;

SELECT SUBSTRING_INDEX(PropertyAddress, ',', 1) PropertyStreet, SUBSTRING_INDEX(PropertyAddress, ',', -1) PropertyCity
FROM nashville_housing;


ALTER TABLE nashville_housing
ADD COLUMN PropertyStreet VARCHAR(255) AFTER PropertyAddress,
ADD COLUMN PropertyCity VARCHAR(255) AFTER PropertyStreet;

UPDATE nashville_housing
SET PropertyStreet = SUBSTRING_INDEX(PropertyAddress, ',', 1),
PropertyCity = SUBSTRING_INDEX(PropertyAddress, ',', -1);

SELECT *
FROM portfolioproject.nashville_housing;



SELECT OwnerAddress
FROM nashville_housing;

ALTER TABLE nashville_housing
ADD COLUMN OwnerStreet VARCHAR(255) AFTER OwnerAddress,
ADD COLUMN OwnerCity VARCHAR(255) AFTER OwnerStreet,
ADD COLUMN OwnerState VARCHAR(255) AFTER OwnerCity;

UPDATE nashville_housing
SET OwnerStreet = SUBSTRING_INDEX(OwnerAddress, ',', 1),
OwnerCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1),
OwnerState = SUBSTRING_INDEX(OwnerAddress, ',', -1);

SELECT *
FROM portfolioproject.nashville_housing;


--------------------------------------------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(soldasvacant), count(SoldAsVacant)
from nashville_housing
group by 1 
order by 2;

SELECT SoldAsVacant,
CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
FROM nashville_housing;

UPDATE nashville_housing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' THEN 'Yes'
WHEN SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END;


-----------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
		PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
        ORDER BY UniqueID
        ) row_num
FROM portfolioproject.nashville_housing
-- order by ParcelID;
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress;

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
		PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
        ORDER BY UniqueID
        ) row_num
FROM portfolioproject.nashville_housing
-- order by ParcelID;
)
DELETE nh
FROM nashville_housing AS nh
JOIN RowNumCTE AS rnc ON nh.UniqueID = rnc.UniqueID
WHERE row_num > 1;


---------------------------------------------------------------------------------------------------------
-- Delete Unused Columns

ALTER TABLE nashville_housing
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress;

SELECT *
FROM portfolioproject.nashville_housing;
