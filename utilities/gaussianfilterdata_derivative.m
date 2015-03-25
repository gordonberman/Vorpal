function out = gaussianfilterdata_derivative(data,sigma)

    L = length(data);
    xx = (1:L) - round(L/2);
    if iscolumn(data)
        xx = xx';
    end
    
    g = -xx.*exp(-.5.*xx.^2./sigma^2)./sqrt(pi*sigma^6);
    out = fftshift(ifft(fft(data).*fft(g)));