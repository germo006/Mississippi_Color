%% Noah Germolus 22 Jan 2021
% I downloaded a gridded SPI data product, and now it's time to slice it
% up.

%ncdisp('../Data/spi_projected_raster_watershed.nc')
%[A,R] = readgeoraster('spi_01_Layer_ProjectRaster_C21.tif')
%mapshow(A,R)

%band = ncread('../Data/spi_projected_raster_watershed.nc','band');
%lat = ncread('../Data/spi_projected_raster_watershed.nc','x');
%long = ncread('../Data/spi_projected_raster_watershed.nc','y');
spi = ncread('../Data/spi_projected_raster_watershed.nc','Extract_spi_1');

spiY = repelem(1895:2020, 12)';
spiM = repmat(1:12, 1, length(1895:2020))';
spiX = str2double(string(spiY) + '.' +...
    strrep(strrep(string(round(spiM./12 - (1/12),3)),'0.',''),'1',''));

c1 = round(1944 + (1/6),3);
c2 = round(1945 + (1/12),3);
c3 = round(1947 + (1/6),3);
c4 = round(2011 + (1/12),3);

spi(:,:,spiX<c1 | spiX>c4 | (spiX>c2 & spiX<c3)) = [];
spiM(spiX<c1 | spiX>c4 | (spiX>c2 & spiX<c3),:) = [];
spiY(spiX<c1 | spiX>c4 | (spiX>c2 & spiX<c3),:) = [];

spi(spi<-100) = NaN;

mean_monthly = reshape(nanmean(nanmean(spi, 1), 2),[size(spi,3),1]);
%plot(spiY+(spiM./12),mean_monthly)

spi = table(spiY, spiM, mean_monthly, 'VariableNames',...
    {'Year', 'Month', 'SPI'});

clear mean_monthly spiY spiM

save('SPImo.mat')

clear spi

spi = ncread('../Data/spi12_projected_raster_watershed.nc','Extract_spi_2');

spiY = repelem(1895:2020, 12)';
spiM = repmat(1:12, 1, length(1895:2020))';

spi(:,:,spiY<1945 | spiY>2011 | spiY==1947 | spiY==1946) = [];
spiM(spiY<1945 | spiY>2011 | spiY==1947 | spiY==1946,:) = [];
spiY(spiY<1945 | spiY>2011 | spiY==1947 | spiY==1946,:) = [];

spi(spi<-100) = NaN;

mean_monthly = reshape(nanmean(nanmean(spi, 1), 2),[size(spi, 3),1]);

%plot(spiY,mean_yearly)

spi = table(spiY, mean_monthly, 'VariableNames',...
    {'Year', 'SPI'});

clear mean_monthly spiY spiM

save('SPIyr.mat')

clear spi
