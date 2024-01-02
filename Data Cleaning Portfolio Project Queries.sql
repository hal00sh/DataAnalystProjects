/*

Cleaning Data in SQL Queries

*/


Select *
From CovidNews1.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDate, CONVERT(Date,SaleDate)
From CovidNews1.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDate1 Date;

Update NashvilleHousing
SET SaleDate1 = CONVERT(Date,SaleDate)



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From CovidNews1.dbo.NashvilleHousing
--Where PropertySplitAddress is null
order by ParcelID



Select a.ParcelID, a.PropertySplitAddress, b.ParcelID, b.PropertySplitAddress, ISNULL(a.PropertySplitAddress,b.PropertySplitAddress)
From CovidNews1.dbo.NashvilleHousing a
JOIN CovidNews1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertySplitAddress is null
select PropertySplitAddress from NashvilleHousing


Update a
SET PropertySplitAddress = ISNULL(a.PropertySplitAddress,b.PropertySplitAddress)
From CovidNews1.dbo.NashvilleHousing a
JOIN CovidNews1.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertySplitAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertySplitAddress
From CovidNews1.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertySplitAddress, 1 , CHARINDEX(',', PropertySplitAddress) -1 ) as Address
, SUBSTRING(PropertySplitAddress, CHARINDEX(',', PropertySplitAddress) + 1 , LEN(PropertySplitAddress)) as Address

From CovidNews1.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress1 Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertySplitAddress, 1, CHARINDEX(',', PropertySplitAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity1 Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertySplitAddress, CHARINDEX(',', PropertySplitAddress) + 1 , LEN(PropertySplitAddress))




Select *
From CovidNews1.dbo.NashvilleHousing





Select OwnerSplitAddress
From CovidNews1.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerSplitAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerSplitAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerSplitAddress, ',', '.') , 1)
From CovidNews1.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress1 Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress1 = PARSENAME(REPLACE(OwnerSplitAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity1 Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity1 = PARSENAME(REPLACE(OwnerSplitAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState1 Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState1 = PARSENAME(REPLACE(OwnerSplitAddress, ',', '.') , 1)



Select *
From CovidNews1.dbo.NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From CovidNews1.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From CovidNews1.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertySplitAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From CovidNews1.dbo.NashvilleHousing
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertySplitAddress

Select *
From CovidNews1.dbo.NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns





Select *
From CovidNews1.dbo.NashvilleHousing


ALTER TABLE CovidNews1.dbo.NashvilleHousing
DROP COLUMN OwnerSplitAddress1, PropertySplitAddress1, SaleDate1

