

-- Cleaning Data in SQL Series


Select*
From CleaningProject..NashvilleHousing


--Standardize Date Format

Select SaleDateConverted, Convert(Date,SaleDate) 
From CleaningProject..NashvilleHousing

--Update NashvilleHousing
--Set SaleDate = Convert(Date,SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
Set SaleDateConverted = Convert(Date,SaleDate)



--Populate Property Address data

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From CleaningProject..NashvilleHousing a
Join CleaningProject..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  And a.[UniqueID ] <> b.[UniqueID ]
 Where a.PropertyAddress is null


Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From CleaningProject..NashvilleHousing a
Join CleaningProject..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--Breaking out address into individual columns

Select PropertyAddress
From CleaningProject..NashvilleHousing
--Order by PropertyAddress

Select
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1), LEN(PropertyAddress)) as Address

From CleaningProject..NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)


Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))


Select*
From CleaningProject..NashvilleHousing




Select OwnerAddress
From CleaningProject..NashvilleHousing

Select
PARSENAME(Replace(OwnerAddress,',','.'), 3)
,PARSENAME(Replace(OwnerAddress,',','.'), 2)
,PARSENAME(Replace(OwnerAddress,',','.'), 1)
From CleaningProject..NashvilleHousing




Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3)


Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2)


Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)


--Select*
--From CleaningProject..NashvilleHousing



--Change Y and N to Yes and No

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From CleaningProject..NashvilleHousing
Group by SoldAsVacant
Order by 2




Select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
       when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
  End
From CleaningProject..NashvilleHousing




Update NashvilleHousing
Set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
                        when SoldAsVacant = 'N' then 'No'
	                    else SoldAsVacant
                   End




-- Remove Duplicates
With RowNumCTE AS(
Select*,
  ROW_NUMBER() Over(
  Partition by ParcelID,
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
  Order by 
               UniqueID

)row_num
From CleaningProject..NashvilleHousing
--order by ParcelID
)

Select*
From RowNumCTE
where row_num > 1
order by PropertyAddress




--Delete Unused Columns


Select*
From CleaningProject..NashvilleHousing

Alter table CleaningProject..NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress


Alter table CleaningProject..NashvilleHousing
drop column SaleDate

































































































