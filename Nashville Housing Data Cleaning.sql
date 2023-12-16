/*

Data Cleaning SQL Project

*/

select *
from Portfolio_projects..NashvilleHousing

-- Standardize Date Format

select SaleDate, CONVERT(Date, SaleDate) AS SaleDateConverted
from Portfolio_projects..NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate)

--
Alter table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)

select *
from Portfolio_projects..NashvilleHousing

--Populate Property Address

Select *
From Portfolio_projects..NashvilleHousing
Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID,b.PropertyAddress, ISNULL(a.propertyAddress,b.propertyAddress) AS MargedPropertyAddress
From Portfolio_projects..NashvilleHousing a
Join Portfolio_projects..NashvilleHousing b ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
Set PropertyAddress =  ISNULL(a.propertyAddress,b.propertyAddress)
From Portfolio_projects..NashvilleHousing a
Join Portfolio_projects..NashvilleHousing b ON a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From Portfolio_projects..NashvilleHousing
order by ParcelID

Select SUBSTRING(propertyAddress, 1, CHARINDEX(',',propertyAddress) -1) AS Address,
		SUBSTRING(propertyAddress,  CHARINDEX(',',propertyAddress) +1, LEN(PropertyAddress)) AS Address


from Portfolio_projects..NashvilleHousing

-- Breaking out The Address using PARSENAME

SELECT PARSENAME(replace(propertyAddress,',', '.'), 2) AS part1,
	PARSENAME(replace(propertyAddress,',', '.'), 1) AS part2
from Portfolio_projects..NashvilleHousing



ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

update NashvilleHousing
set PropertySplitAddress =SUBSTRING(propertyAddress, 1, CHARINDEX(',',propertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


update NashvilleHousing
SET PropertySplitCity = SUBSTRING(propertyAddress,  CHARINDEX(',',propertyAddress) +1, LEN(PropertyAddress))



SELECT *
from Portfolio_projects..NashvilleHousing




SELECT OwnerAddress
from Portfolio_projects..NashvilleHousing

Select OwnerAddress, PARSENAME(Replace( OwnerAddress, ',', '.'), 3) AS Part1,
					 PARSENAME(Replace( OwnerAddress, ',', '.'), 2) AS Part2,
					 PARSENAME(Replace( OwnerAddress, ',', '.'), 1) AS Part3
from Portfolio_projects..NashvilleHousing



Select OwnerSplitAddress,OwnerSplitCity,OwnerSplitState
from Portfolio_projects..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress =PARSENAME(Replace( OwnerAddress, ',', '.'), 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity =PARSENAME(Replace( OwnerAddress, ',', '.'), 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState =PARSENAME(Replace( OwnerAddress, ',', '.'), 1)


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), COUNT(SoldAsVacant) AS Total
from Portfolio_projects..NashvilleHousing
GROUP BY SoldAsVacant
Order by Total

Select SoldAsVacant,
CASE
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	  ELSE SoldAsVacant
	end
from Portfolio_projects..NashvilleHousing

Update NashvilleHousing
set SoldAsVacant = CASE
	when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	  ELSE SoldAsVacant
	end

-- Remove Duplicates

--Display the Dublicates

WITH RowNumberCTE AS(
Select *,
	ROW_NUMBER() OVER (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) AS row_num
	 

From NashvilleHousing
--order by ParcelID
)
Select *
From RowNumberCTE
where row_num > 1
order by PropertyAddress

--Delete Dublicates From The Table
/*
DELETE
From RowNumberCTE
where row_num > 1

*/



select *
from NashvilleHousing

-- Delete Unused Columns

Select *
from Portfolio_projects..NashvilleHousing

Alter table Portfolio_projects..NashvilleHousing
Drop Column OwnerAddress,TaxDistrict,PropertyAddress,SaleDate