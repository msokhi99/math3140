% Currently the program behaves according to the following parameters: 
% Width = 50.
% Height = 50.
% Empty Ratio = 0.7.
% Similarity Threshold = 0.7.
% Total Iterations = 100.
% File Name = Segregate Agents.

% Fills in the paramters.
schRun = FunctionsForShellingModel(50, 50, 0.7, 0.7, 100, ...
    'Segregate Agents');

% Calls the function populate() to randomly populate the grid.
schRun = schRun.populate();

% Calls the function update() to update the radomized grid.
schRun.update();

