numberOfSteps = 40000; % Length of the Walk.

x(1) = 0;              % Initial Pos. of (x).
y(1) = 0;              % Initial Pos. of (y).

for i = 1:numberOfSteps
    
    theta = 2*pi*rand();    % Arbritrary angle between 0 and 2PI.
    r = 1.0;                % Unit Step Size.
    
    dx = r*cos(theta);      % Step Size of (x).
    dy = r*sin(theta);      % Step Size of (y).
    
    x(i+1) = x(i) + dx;     % Step Size of the i'th pos. of (x).
    y(i+1) = y(i) + dy;     % Step Size of the i'th pos. of (y).
       
end

plot(x,y,'k');              % Plotting (x) and (y) in Black.
hold on

dist = sqrt(x.^2 + y.^2);   % Length of each Step Size.

int = (dist > 100) & (dist < 200);    % Storing all the 'Walks' that are
                                      % between (100,200).
                                  
scatter(x(int), y(int), 'r.');    % Scatter plot to plot 'Walks' that
                                  % are in between (100,200) along with 
                                  % all the other 'Walks'.

title("Random Walk V/s Interval Walk");
grid; xlabel("X-Coordinates"); ylabel("Y-Coordinates");
legend('RandomWalk','IntervalWalk');
hold off