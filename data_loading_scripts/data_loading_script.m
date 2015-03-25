numPoints = 100;
N = 
xx = linspace(0,1,numPoints);
allVocs = zeros(N,numPoints);
allAmps = zeros(N,numPoints);
durations = zeros(N,1);
individualNum = zeros(N,1);
count = 1;
for i=1:16
    individualNum(count - 1 + (1:soloMaleLengths(i))) = i;
    for j=1:soloMaleLengths(i)
        x = soloMaleFreqContours(i).vocs{j};idx = find([1 diff(x(1,:))]~=0);x = x(:,idx);
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
for i=1:19
    individualNum(count - 1 + (1:femaleExpLengths(i))) = i + 16;
    for j=1:femaleExpLengths(i)
        x = femaleExpFreqContours(i).vocs{j};idx = find([1 diff(x(1,:))]~=0);x = x(:,idx);
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