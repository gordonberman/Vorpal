files = findImagesInFolder('/Users/gberman/Dropbox/WorkWithOthers/Janelia/Roian/manual_labels/','mat');

L = length(files);
for i=1:L
    load(files{i})
end



numPoints = 100;
Nch = 0;
Nfm = 0;
Nst = 0;
Ndn = 0;
Nms = 0;
Ncf = 0;
chLengths = zeros(5,1);
fmLengths = zeros(5,1);
stLengths = zeros(5,1);
dnLengths = zeros(4,1);
msLengths = zeros(4,1);
cfLengths = zeros(5,1);

for i=1:5
    Nch = Nch + length(ch_fcontours(i).vocs);
    chLengths(i) = length(ch_fcontours(i).vocs);
end

for i=1:5
    Nfm = Nfm + length(fm_fcontours(i).vocs);
    fmLengths(i) = length(fm_fcontours(i).vocs);
end

for i=1:5
    Nst = Nst + length(st_fcontours(i).vocs);
    stLengths(i) = length(st_fcontours(i).vocs);
end

for i=1:4
    Ndn = Ndn + length(dn_fcontours(i).vocs);
    dnLengths(i) = length(dn_fcontours(i).vocs);
end

for i=1:4
    Nms = Nms + length(ms_fcontours(i).vocs);
    msLengths(i) = length(ms_fcontours(i).vocs);
end

for i=1:5
    Ncf = Ncf + length(cf_fcontours(i).vocs);
    cfLengths(i) = length(cf_fcontours(i).vocs);
end

N = Nst + Nfm + Nch + Ndn + Nms + Ncf;
Ns = [Nch Nfm Nst Ndn Nms Ncf];
m = cumsum(Ns);

isChevron = false(N,1);
isChevron(1:m(1)) = true;

isFM = false(N,1);
isFM(m(1)+1:m(2)) = true;

isStep = false(N,1);
isStep(m(2)+1:m(3)) = true;

isDown = false(N,1);
isDown(m(3)+1:m(4)) = true;

isMulti = false(N,1);
isMulti(m(4)+1:m(5)) = true;

isConstant = false(N,1);
isConstant(m(5)+1:m(6)) = true;

xx = linspace(0,1,numPoints);
allVocs = zeros(N,numPoints);
allAmps = zeros(N,numPoints);
durations = zeros(N,1);
individualNum = zeros(N,1);


count = 1;
for i=1:5
    individualNum(count - 1 + (1:chLengths(i))) = i;
    for j=1:chLengths(i)
        x = ch_fcontours(i).vocs{j};
        idx = find([1 diff(x(1,:))]~=0);
        x = x(:,idx);
        durations(count) = x(1,end) - x(1,1);
        a = fit(x(1,:)',x(2,:)','spline');
        allVocs(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        a = fit(x(1,:)',x(3,:)','spline');
        allAmps(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        clear a
        count = count + 1;
    end
    i
end


for i=1:5
    individualNum(count - 1 + (1:fmLengths(i))) = i;
    for j=1:fmLengths(i)
        x = fm_fcontours(i).vocs{j};
        idx = find([1 diff(x(1,:))]~=0);
        x = x(:,idx);
        durations(count) = x(1,end) - x(1,1);
        a = fit(x(1,:)',x(2,:)','spline');
        allVocs(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        a = fit(x(1,:)',x(3,:)','spline');
        allAmps(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        clear a
        count = count + 1;
    end
    i
end


for i=1:5
    individualNum(count - 1 + (1:stLengths(i))) = i;
    for j=1:stLengths(i)
        x = st_fcontours(i).vocs{j};
        idx = find([1 diff(x(1,:))]~=0);
        x = x(:,idx);
        durations(count) = x(1,end) - x(1,1);
        a = fit(x(1,:)',x(2,:)','spline');
        allVocs(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        a = fit(x(1,:)',x(3,:)','spline');
        allAmps(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        clear a
        count = count + 1;
    end
    i
end


for i=1:4
    
    if i < 4
        individualNum(count - 1 + (1:dnLengths(i))) = i;
    else
        individualNum(count - 1 + (1:dnLengths(i))) = 5;
    end
    
    for j=1:dnLengths(i)
        x = dn_fcontours(i).vocs{j};
        idx = find([1 diff(x(1,:))]~=0);
        x = x(:,idx);
        durations(count) = x(1,end) - x(1,1);
        a = fit(x(1,:)',x(2,:)','spline');
        allVocs(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        a = fit(x(1,:)',x(3,:)','spline');
        allAmps(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        clear a
        count = count + 1;
    end
    i
end


for i=1:4
    
    if i < 4
        individualNum(count - 1 + (1:msLengths(i))) = i;
    else
        individualNum(count - 1 + (1:msLengths(i))) = 5;
    end
    
    for j=1:msLengths(i)
        x = ms_fcontours(i).vocs{j};
        idx = find([1 diff(x(1,:))]~=0);
        x = x(:,idx);
        durations(count) = x(1,end) - x(1,1);
        a = fit(x(1,:)',x(2,:)','spline');
        allVocs(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        a = fit(x(1,:)',x(3,:)','spline');
        allAmps(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        clear a
        count = count + 1;
    end
    i
end


for i=1:5
    
    individualNum(count - 1 + (1:cfLengths(i))) = i;

    for j=1:cfLengths(i)
        x = cf_fcontours(i).vocs{j};
        idx = find([1 diff(x(1,:))]~=0);
        x = x(:,idx);
        durations(count) = x(1,end) - x(1,1);
        a = fit(x(1,:)',x(2,:)','spline');
        allVocs(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        a = fit(x(1,:)',x(3,:)','spline');
        allAmps(count,:) = a(linspace(x(1,1),x(1,end),numPoints));
        clear a
        count = count + 1;
    end
    i
end

meanValues = mean(allVocs,2);
allVocs_scaled = bsxfun(@minus,allVocs,meanValues);


