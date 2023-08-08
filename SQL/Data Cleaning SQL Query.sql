
---------------------------------------------------------------------------------------
/*

Cleaning Data in SQL Queries 

*/

Select * 
from PortfolioProject..NashvilleHousing

---------------------------------------------------------------------------------------
-- Standardize Date Format

select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject..NashvilleHousing

Update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

ALter table NashvilleHousing
add SaleDateConverted Date

Update NashvilleHousing
set SaleDateConverted = CONVERT(date, SaleDate)


---------------------------------------------------------------------------------------
-- Populate Property Address data
select * 
from PortfolioProject..NashvilleHousing
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
From PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) 
From PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
join PortfolioProject..NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null









---------------------------------------------------------------------------------------
-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
From PortfolioProject..NashvilleHousing

select 
substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address
from PortfolioProject..NashvilleHousing

select 
substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as City
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255)

update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255)

update NashvilleHousing
set PropertySplitCity =substring(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select * from PortfolioProject..NashvilleHousing



select OwnerAddress 
From PortfolioProject..NashvilleHousing

select 
PARSENAME(replace(OwnerAddress, ',','.'),3) as Address,
PARSENAME(replace(OwnerAddress, ',','.'),2) as City,
PARSENAME(replace(OwnerAddress, ',','.'),1) as State
from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
add OwnerSplitAddress Nvarchar(255)
update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress, ',','.'),3)

Alter Table NashvilleHousing
add OwnerSplitCity Nvarchar(255)
update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress, ',','.'),2)

Alter Table NashvilleHousing
add OwnerSplitState Nvarchar(255)
update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress, ',','.'),1)

select * from PortfolioProject..NashvilleHousing

---------------------------------------------------------------------------------------
-- Change Y and N to Yes and No in "Sold as Vacant" field

--checking 
select distinct(SoldAsVacant), COUNT(SoldAsVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end
from PortfolioProject..NashvilleHousing


update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant ='Y' then 'Yes'
when SoldAsVacant ='N' then 'No'
else SoldAsVacant
end




---------------------------------------------------------------------------------------
-- Remove Duplicates
select * 
from 
PortfolioProject..NashvilleHousing

With RowNumCTE AS(
select *,
ROW_NUMBER() over(
partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			Order by UniqueID) row_num
from PortfolioProject..NashvilleHousing
)

Delete 
from RowNumCTE
where row_num >1
--Order by PropertyAddress

select * 
from RowNumCTE
where row_num>1
Order by PropertyAddress




---------------------------------------------------------------------------------------
-- Delete Unused Columns

select *
from PortfolioProject..NashvilleHousing

Alter Table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

Alter Table NashvilleHousing
drop column SaleDate




---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------





