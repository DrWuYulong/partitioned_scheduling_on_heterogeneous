function part = DKW(topology,m,subtask_numb)
% direct k-way (DKW) partitioning algorithm 
lb = 0.9 * subtask_numb/m;

part = randi([1 m],1,subtask_numb);
% part = BLM(C,topology,m,subtask_numb);

% part = ones(1,subtask_numb)*m;

free = ones(1,subtask_numb);

gain = zeros(m,subtask_numb);

numb_V = zeros(1,m); %m个划分，每个划分当前子任务个数

for i = 1:m-1
    set = find(sum(topology) == 0);
    for k = 1:subtask_numb
        if free(topology(:,k) == 1) == 0
            set = union(set, k);
        end
    end
    
    empty_index = find(free ==0);
    while ~isempty(empty_index)
        set(set == empty_index(1)) = [];
        empty_index(1) = [];
    end

    
    for k = 1:length(set)
        u = set(k);
        gain(i,u) = CompGain(topology,u,part,i);
    end
    
    heap = set;
%     heap = heap(1);

    while numb_V(i) < lb
%         max_heap = max(gain(i,heap));
        u = heap(gain(i,heap) == max(gain(i,heap)));
        u = intersect(u,find(free == 1));

        if isempty(u)
            break;
        end
        u = u(1);
        heap(heap == u) = [];
        part(u) = i;
        numb_V(i) = numb_V(i) + 1;
        free(u) = 0;
        succ_u = find(topology(u,:) == 1);
        for k = 1:length(succ_u)
            v = succ_u(k);
            ready = 1;
            pred_v = find(topology(:,v) == 1);
            for l = 1:length(pred_v)
                w = pred_v(l);
                if free(w) == 1
                    ready = 0;
                end
            end
            if ready
                gain(i,v) = CompGain(topology,v,part,i);
                heap = union(heap,v); 
            end
        end
    end
    
  
end
    
    
    
end