% A lot of the For - Loops could have been avoided and replaced with a 
% vectorized version of the code, but a lot of the times the code
% implemented using a For - Loop was easier to follow than a vectorized
% version of the code which was getting way too complex and hard to follow.
% It also was messing up with the whole nature of the program and throwing
% exceptions left and right. As such, I do think the computation times on
% these models depend vastly on the amount of memory and RAM dedicated to
% these softwares. A simple computation involving a 20x20 grid took merely
% 1.3 seconds on average on my Desktop computer, whereas the same grid took
% 7.3 seconds on average on my Laptop.

% Class Name
classdef FunctionsForShellingModel
    
    %Properties Of The Class
    properties
        width
        height
        empty_ratio
        similarity_threshold
        n_iterations
        agents
        file_name
    end
    
    methods
        function obj = FunctionsForShellingModel(width, height, ...
                empty_ratio, similarity_threshold, n_iterations, file_name)
            obj.width = width;
            obj.height = height;
            obj.empty_ratio = empty_ratio;
            obj.similarity_threshold = similarity_threshold;
            obj.n_iterations = n_iterations;
            obj.agents = zeros(obj.width, obj.height);
            obj.file_name = file_name;
        end
        
        function obj = populate(obj)
            %Randi = Uniformly distributed pseudorandom integers.
            obj.agents = randi([0 1], obj.width, obj.height);
            % The above creates a m x n matrix where m = (obj.width) and n
            % = (obj.height) respectively. For example, if m = 10 and n =
            % 10, then we get a uniformly distributed pseudorandom integers
            % of 1's and 0's.
            obj.agents(obj.agents == 0) = -1;
            % All the numbers that are 0 in the above matrix are replaced
            % by a -1. So, now we have a 10x10 matrix of 1's and -1's.
            empty_index = randi([1 obj.width*obj.height], 1, ...
                obj.width*obj.height*obj.empty_ratio);
            % Assume the empty_ratio = 0.7. The above creates a matrix of
            % size 1x70 with uniformly distributed pseudorandom integers
            % between (1 100).
            obj.agents(empty_index) = 0;
            % The agent matrix containing only the 1's and -1's are being
            % put to use here. Random entries of this matrix are being
            % changed to a 0. Here, we still have a 10x10 matrix.
        end
        
        function val = is_unsatisfied(obj, x, y)
        % Function contains 3 formal paramteres, namely obj,x,y.  
            current_agent = obj.agents(x, y);
            % Declaring a variable current_agent which is initialized to a
            % random agents (x,y) coordinate ... suppose (4,8).
            count_similar = 0;
            % Declaring a variable count_similar and initializing it to 0.
            count_different = 0;
            % Declaring a variable count_different and initialzing it to 0.
            neighbours_index = obj.get_neighbours_index(x, y);
            % Declaring a variable neighbours_index which is initialized to
            % a random agents 'Neighbours' (x,y) coordinate ...suppose
            % (10,5).
            for i=1:1:length(neighbours_index)
            % Will loop from 1 to total length of neighbours index. For
            % example, if neighbours index is (5,15) .. total length is
            % 15-5 = 10. So this will loop from i = 1 - 10.
                if current_agent == obj.agents(neighbours_index(i))
                    count_similar = count_similar+1;
                % If the position of the current agent is equal to the
                % position of the neighbouring agent then we add + 1 count
                % to count_similar, which in this case is initialized to 0.
                % Therefore, if this is true, count_similar will be 1.
                elseif  current_agent == -obj.agents(neighbours_index(i))
                    count_different = count_different+1;
                % If the position of the current agent is equal to
                % the 'negative' position of the neighbouring agent
                % then we add + 1 count to count_different, which
                % in this case is initialized to 0. Therefore, if
                % this is true, count_different will be 1.
                end
            end
            if count_similar+count_similar == 0
                val = true;
            % If both the counts added up are 0 then the function will
            % return its value as True.
            else
                val = (count_similar/(count_similar+count_different)) ...
                    < obj.similarity_threshold;
            % If count1 + count2 != 0, then the value of val will
            % be a double value (depending on the choice of the
            % similarity threshold).
            end
        end
        
        function update(obj)
            agent_matrix = zeros(obj.width,obj.height,obj.n_iterations);
            % Creates a zero matrix of size mxn .. from above in this
            % example = 10x10. Assume, n_iterations = 10. This will display
            % 10 zero matrices of size 10x10.
            agent_matrix(:,:,1) = obj.agents(:,:);
            
            
            for i=2:1:obj.n_iterations
                n_changes = 0;
                for j = 1:1:obj.width*obj.height
                    [x,y] = ind2sub([obj.width, obj.height],j);
                    if obj.agents(x,y) == 0
                        continue;
                    end
                    if is_unsatisfied(obj,x,y) ~= 0
                        obj = move_to_empty(obj,x,y);
                        n_changes = n_changes+1;
                    % If the is_unsatisfied function as defined above is
                    % eualt to 0 then we move the object to an empty
                    % unoccupied square. To keep track of these changes we
                    % have a counter defined as n_changes which is
                    % initialzed to 0.
                    end
                end
                spy(obj.agents(:,:) == -1,'g');
                % Dispalying the sparsity pattern of matrix. Agents
                % corresponding to a value of -1 are colored green.
                hold on
                spy(obj.agents(:,:) == 1, 'b');
                % Dispalying the sparsity pattern of matrix. Agents
                % corresponding to a value of -1 are colored black.
                hold off
                legend('Population 1','Population 2')
                pause(0.05);
                % Pausing the plotting for 0.5 seconds for better
                % visuality.
                agent_matrix(:,:,i) = obj.agents(:,:);
                fprintf('Iteration %d, changed %d \n',i,n_changes);
                if n_changes == 0
                    fprintf('The System Has Been Stabilized\n');
                % If there are no changes to be made in the system the
                % program will display the above message to the user.
                    break;
                end
            end
            agent_matrix = agent_matrix(:,:,1:i);
            save(obj.file_name, 'agent_matrix','-v7.3');
        end
        
        
        function obj = move_to_empty(obj, x, y)
        % Function contains 3 formal paramteres, namely obj,x,y.
            current_agent = obj.agents(x, y);
            % Declaring a variable current_agent and setting it equal to
            % the coordinate of the current agent (x,y).
            empty_squares = find(obj.agents==0);
            % Declaring a variable empty_squares and setting it equal to
            % the matrix of agents defined in the first function whose
            % entries are = 0.
            index_to_move = randi([1 length(empty_squares)],1);
            % Declaring a variable index_to_move which is a 1x1 matrix if
            % pseudorandom integers between 1 and the length of the
            % empty_squares.
            obj.agents(empty_squares(index_to_move)) = current_agent;
            obj.agents(x, y) = 0;
        end
        
        function [indexes] = get_neighbours_index(obj, x, y)
            % Function creates an array of the position of the neighbouring
            % agents location (x,y).
            indexes = [];
            % A bunch of if's to convert subscripts to linear indices which
            % is then used in the above function to update the neighbouring
            % agents position. The following contains all scenarios for a
            % cross shaped neighbourhood.
            if x>1
                indexes = [ indexes sub2ind([obj.width, obj.height]...
                    ,x-1, y)];
                if y>1
                    indexes =[ indexes sub2ind([obj.width, obj.height]...
                        ,x-1, y-1)];
                end
                if y<obj.height
                    indexes =[ indexes sub2ind([obj.width, obj.height]...
                        ,x-1, y+1)];
                end
            end
            
            if x<obj.width
                indexes =[ indexes sub2ind([obj.width, obj.height],...
                    x+1, y)];
                if y>1
                    indexes =[ indexes sub2ind([obj.width, obj.height]...
                        ,x+1, y-1)];
                end
                if y<obj.height
                    indexes =[ indexes sub2ind([obj.width, obj.height],...
                        x+1, y+1)];
                end
            end
            
            if y<obj.height
                indexes =[ indexes sub2ind([obj.width, obj.height],...
                    x, y+1)];
            end
            
            if y<obj.height && y>1
                indexes =[ indexes sub2ind([obj.width, obj.height],...
                    x, y-1)];
            end
        end
        
    end
    
end

