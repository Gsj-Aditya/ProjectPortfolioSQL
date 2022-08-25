/* 

Data Cleaning Using SQL

*/

Select * from PortfolioProject..housingdata


/*  Standarizing Date Format */

Select SaleDate1 from PortfolioProject..housingdata

ALTER TABLE PortfolioProject..housingdata
ADD SaleDate1 date

UPDATE PortfolioProject..housingdata
SET SaleDate1 = CONVERT(date,SaleDate)

UPDATE PortfolioProject..housingdata
SET SaleDate = SaleDate1




/*  Populate Property Address Data */


Select ISNULL(a.PropertyAddress, b.PropertyAddress ),
a.ParcelID,b.ParcelID,a.PropertyAddress, b.PropertyAddress from PortfolioProject..housingdata a
join PortfolioProject..housingdata b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null

UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress )
from PortfolioProject..housingdata a
join PortfolioProject..housingdata b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null





/*  Breaking Out PropertyAddress into Individual Columns ( Address, City, USING SUBSTRING AND CHARINDEX FUNCTIONS */

Select PropertyAddress from PortfolioProject..housingdata

ALTER TABLE PortfolioProject..housingdata
ADD PropertySplitAddress nvarchar(255)

Update PortfolioProject..housingdata
SET PropertySplitAddress = SUBSTRING( PropertyAddress,1, CHARINDEX (',', PropertyAddress) - 1) from PortfolioProject..housingdata

ALTER TABLE PortfolioProject..housingdata
ADD PropertySplitCity nvarchar(255)


Update PortfolioProject..housingdata
SET PropertySplitCity =  SUBSTRING( PropertyAddress, CHARINDEX (',', PropertyAddress) + 1, len(PropertyAddress)) from PortfolioProject..housingdata

Select PropertySplitCity,PropertySplitAddress from PortfolioProject..housingdata



/*  Breaking Out OwnerAddress into Individual Columns ( Address, City, State ), USING PARSENAME FUNCTIONS */

Select OwnerAddress from PortfolioProject..housingdata where OwnerAddress is not null

 ALTER TABLE PortfolioProject..housingdata
 ADD OwnerAddress1 nvarchar (400)

 UPDATE PortfolioProject..housingdata
 SET OwnerAddress1 = PARSENAME(REPLACE(OwnerAddress ,',','.'),3) from PortfolioProject..housingdata where OwnerAddress is not null



 ALTER TABLE PortfolioProject..housingdata
 ADD OwnerCity nvarchar (400)

  UPDATE PortfolioProject..housingdata
 SET OwnerCity = PARSENAME(REPLACE(OwnerAddress ,',','.'),2) from PortfolioProject..housingdata where OwnerAddress is not null



 ALTER TABLE PortfolioProject..housingdata
 ADD OwnerState nvarchar (400)

 UPDATE PortfolioProject..housingdata
 SET OwnerState = PARSENAME(REPLACE(OwnerAddress ,',','.'),1) from PortfolioProject..housingdata where OwnerAddress is not null

 Select OwnerAddress1, OwnerCity , OwnerState from PortfolioProject..housingdata where OwnerAddress1 is  not null



 /*  Change N and Y to No and Yes respectively in "Sold as Vacant" Field, USING CASE STATEMENT */

 Select Distinct(SoldAsVacant),COUNT(SoldAsVacant) from PortfolioProject..housingdata
 GROUP BY SoldAsVacant
 Order by 2

 Select SoldAsVacant,
   CASE when SoldAsVacant = 'N' THEN 'No'
   When SoldAsVacant = 'Y' THEN 'YES'
   ELSE SoldAsVacant
   END
   from PortfolioProject..housingdata
  

  /*  Deleting Unused Columns */

  Select * from PortfolioProject..housingdata

  ALTER TABLE PortfolioProject..housingdata
  DROP COLUMN OwnerAddress,PropertyAddress
