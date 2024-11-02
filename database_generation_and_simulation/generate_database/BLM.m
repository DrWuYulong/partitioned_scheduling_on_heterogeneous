function partitioned_results = BLM(C,E,types,subtasks_types)

%%%%%%%%%%% 计算bl
partitioned_results = zeros(1,length(C));
bl = zeros(1,length(C));
curr_bl = find(sum(E,2) == 0);
blPart = zeros(1,length(types));

while ~isempty(curr_bl)
    vi = curr_bl(end);
    curr_bl(end) = [];
    if sum(E(vi,:)) == 0 %表示末节点
        bl(vi) = C(vi);
    else
        bl_i = C(vi) + max(bl(E(vi,:) == 1));
        bl(vi) = max(bl(vi),bl_i);
    end
    
    curr_bl = union(find(E(:,vi) == 1),curr_bl);

end
%%%%%%%%% bl计算结束

for l = 1:length(types)
    max_bl = max(bl(find(subtasks_types == 1)));
    max_bl = max_bl(1);
    blPart(l) = max_bl;
end

ReadyParts = find(sum(E) == 0);

comp = zeros(1,sum(types));
send = comp;
recv = comp;

begin = comp;
st = comp;
temp_E = E;

unallocated_subtasks = 1:length(C);

while ~isempty(ReadyParts)
    
    vi = ReadyParts(find(bl(ReadyParts) == max(bl(ReadyParts))));
    vi = vi(1);
    unallocated_subtasks(unallocated_subtasks == vi) = [];
    ReadyParts(ReadyParts == vi) = [];
    %%%%% 找到vi适合的type索引
    vi_core_begin = sum(types(1:subtasks_types(vi)-1)) + 1;
    vi_core_range = vi_core_begin:vi_core_begin + types(subtasks_types(vi))-1;%vi的type对应core的索引范围
    for k = vi_core_range
        send_new = send;
        recv_new = recv;
        comp_new = comp;
        
        begin(k) = comp_new(k);
        
        Pred_vi = find(E(:,vi) == 1);
        for j = 1:length(Pred_vi)
            vj = Pred_vi(j);
            if partitioned_results(vj) == k
                t = st(vj) + C(vj);
            else
                t = max([st(vj)+C(vj),send_new(partitioned_results(vj)),recv_new(k)]);
                send_new(partitioned_results(vj)) = t;
                recv_new(k) = t;
            end
            begin(k) = max(begin(k),t);
        end
        
        comp_new(k) = begin(k) + C(vi);
    end
    
    k_star = vi_core_range(find(comp_new(vi_core_range) == min(comp_new(vi_core_range))));
    k_star = k_star(1);
    
    partitioned_results(vi) = k_star;
    st(vi) = comp_new(k_star);
    Pred_vi = find(E(:,vi) == 1);
    for j = 1:length(Pred_vi)
        vj = Pred_vi(j);
        if partitioned_results(vj) == k_star
            com_ji = st(vj) + C(vj);
        else
            com_ji = max([st(vj)+C(vj),send(partitioned_results(vj)),recv(k_star)]);
            send_new(partitioned_results(vj)) = com_ji;
            recv_new(k) = com_ji;
        end
        st(vi) = max([st(vi),com_ji]);
    end
    comp_new(k_star) = st(vi) + C(vi);
    
    %%%%% 插入新的ready
    temp_E(vi,:) = 0;
   
    new_ready = intersect(find(sum(temp_E) == 0),unallocated_subtasks);
    ReadyParts = union(new_ready,ReadyParts);

        

end   



% 
% 
% 
% all_part = 1:types;
% % part = randi([1 m],1,subtask_numb);
% part = mod(1:subtasks_types,types)+1;
% % part = dagP(E,m,subtask_numb)
% % pause;
% 
% ReadyParts = part(sum(E) == 0);
% ReadyParts = union(ReadyParts,ReadyParts);
% all_part(ReadyParts) = [];
% scheduled = zeros(1,subtasks_types);
% scheduled(sum(E) == 0) = 1;
% 
% end_k = zeros(1,types);
% comp_k = end_k;
% recv_k = end_k;
% send_k = end_k;
% st = zeros(1,subtasks_types);
% 
% miu = ones(1,subtasks_types);
% 
% valid_processors = 1:types;
% 
% while ~isempty(ReadyParts)
%     Vi = ReadyParts(1);
%     all_part(all_part == Vi) = [];
%     ReadyParts(1) = [];
%     curr_ReadyPart = find(part == Vi);
%     for k = 1:types
%         end_k(k) = comp_k(k);
%         Ready = curr_ReadyPart(find(scheduled(curr_ReadyPart) == 1));
%         
%         for ttt = 1:length(curr_ReadyPart)
%             if part(find(E(:,curr_ReadyPart(ttt)))) == 1
%                 Ready = union(Ready,ttt);
%             end
%         end
%         
%         if ~isempty(Ready)
%             Ready = Ready(1);
%         end
% 
%         while ~isempty(Ready)
%             vx = Ready(1);
%             Ready(1) = [];
%             pred_vx = find(E(:,vx) == 1);
%             %%%%%%bl 越小 finish 越大，pred_vx按照finish升序排列，也就是按照bl降序排列
%             for ii = 1:length(pred_vx)-1
%                 for jj = ii:length(pred_vx)
%                     if bl(pred_vx(jj)) > bl(pred_vx(ii))
%                         temp_store = pred_vx(ii);
%                         pred_vx(ii) = pred_vx(jj);
%                         pred_vx(jj) = temp_store;
%                     end
%                 end
%             end
%             
%             miu(curr_ReadyPart) = k;
%             st(vx) = comp_k(k);
%             
%             for l = 1:length(pred_vx)
%                 vj = pred_vx(l);
%                 if miu(vj) == k
%                     com_jx = st(vj) + C(vj);
%                 else
%                     com_jx = max([st(vj) + C(vj), send_k(miu(vj)), recv_k(k)]);
%                     send_k(miu(vj)) = com_jx;
%                     recv_k(k) = com_jx;
%                 end
%                 st(vx) = max(st(vx), com_jx);
%             end
%             comp_k(k) = st(vx) + C(vx);
%             end_k(k) = comp_k(k);
%             scheduled(vx) = 1;
%             %%%%%%%%%insert new ready tasks into Ready
%             un_execute = find(scheduled == 0);
%             pre_v = intersect(un_execute,curr_ReadyPart);
% 
%             for l = 1:length(pre_v)
%                 pred_y = find(E(:,pre_v(l)) == 1);
%                 if scheduled(pred_y) == 1
%                     Ready = union(Ready,pre_v(l));
%                 end
%             end
%         end
%     end
%     temp_endk =end_k;
%     temp_endk = temp_endk(valid_processors);
%     temp_index = find(temp_endk == min(temp_endk));
%     temp_index = temp_index(1);
%     k_opt = valid_processors(temp_index);
%     valid_processors(temp_index) = [];
%     
% %     end_k
% %     k_opt = find(end_k ==min(end_k))
% %     pause;
% %     k_opt = intersect(k_opt,valid_processors)
% %     k_opt = k_opt(1);
% %     valid_processors(valid_processors == k_opt) = [];
%     partitioned_results(find(part == Vi)) = k_opt;
%         
%     tt = [];
%     %%%%%%%%%%找到新的 ready part 放到 ReadyPart List
%     for kk = 1:length(all_part)
%         check_Vx =  find(part == all_part(kk));
%         for ll = 1:length(check_Vx)
%             if scheduled(find(E(:,check_Vx(ll)) == 1)) == 1
%                ReadyParts = union(ReadyParts, all_part(kk));
%                tt = [tt kk];
%                break;
%             end
%         end
%     end
%     if ~isempty(tt)
% %         all_part(find(all_part == tt)) = [];
%         all_part(tt) = [];
%     end
%         
% end
% 
% if ~isempty(valid_processors)
%     partitioned_results(partitioned_results == 0) = valid_processors(1);
% end
% 
% end











