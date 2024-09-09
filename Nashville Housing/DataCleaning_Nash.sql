Select *
From [Nashville Housing].dbo.NashvilleHousing;

USE [Nashville Housing];
GO


----------------------------------------------------Standardize Date Format-----------------------------------------------------------------

SELECT SaleDate
From [Nashville Housing].dbo.NashvilleHousing;

SELECT SaleDate ,CONVERT(Date,SaleDate) AS Formated_SaleData
From NashvilleHousing;

UPDATE NashvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate);

ALTER Table NashvilleHousing
Add SaleDateConverted Date;

Update [Nashville Housing].dbo.NashvilleHousing
Set SaleDateConverted = CONVERT(Date,SaleDate);

Select SaleDateConverted
From NashvilleHousing;

------------------------------------------------------------Populate Property Address data-----------------------------------------------------

Select *
From NashvilleHousing
--Where PropertyAddress is NULL
order by ParcelID;


Select * 
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID 
	And a.[UniqueID ] <> b.[UniqueID ];


Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID 
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null;


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID 
	And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null;

---------------------------------------------Breaking out Address into Individual Coulmn (Address,City,State)-----------------------------


Select PropertyAddress
From NashvilleHousing;

Select PropertyAddress,SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1 ,LEN(PropertyAddress)) AS City
From NashvilleHousing;



ALTER Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)




ALTER Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+ 1 ,LEN(PropertyAddress))

SELECT PropertySplitAddress,PropertySplitCity From NashvilleHousing;












Select OwnerAddress
From NashvilleHousing;

SELECT 
	OwnerAddress,
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) AS Part1,  -- Last part after the last comma
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) AS Part2,  -- Second to last part
    PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) AS Part3   -- Third to last part
FROM NashvilleHousing;




ALTER Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);




ALTER Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2);




ALTER Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


Select * from NashvilleHousing;



----------------------------------------------------------------------------


SELECT DISTINCT(SoldAsVacant),Count(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;




SELECT SoldAsVacant,
	CASE WHEN  SoldAsVacant = 'N' THEN 'No'
		 WHEN  SoldAsVacant = 'Y' THEN 'Yes'
		 ELSE SoldAsVacant
	End AS SoldAsVacantFlagged
From NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN  SoldAsVacant = 'N' THEN 'No'
		 WHEN  SoldAsVacant = 'Y' THEN 'Yes'
		 ELSE SoldAsVacant
		End ;

SELECT DISTINCT(SoldAsVacant),Count(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2;


------------------------Remove Duplicates----------------------------------
WITH ROWNUMCTE AS (
Select * ,
ROW_NUMBER()OVER(
			PARTITION BY ParcelID,PropertyAddress,SaleDate,SalePrice,LegalReference
			Order BY UniqueID) row_num
From NashvilleHousing)
Delete
From ROWNUMCTE
where row_num > 1;

------------------------------Delete Unuesd Coulmns-------------------------------------


Select * From NashvilleHousing;


Alter Table NashvilleHousing

Drop Column OwnerAddress,PropertyAddress

Alter Table NashvilleHousing
DROP Column SaleDate,TaxDistrict;

Select * From NashvilleHousing;