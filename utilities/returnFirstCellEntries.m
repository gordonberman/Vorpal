function values = returnFirstCellEntries(data)

    L = length(data(:));
    values = zeros(size(data));
    
    for i=1:L
        values(i) = data{i}(1);
    end