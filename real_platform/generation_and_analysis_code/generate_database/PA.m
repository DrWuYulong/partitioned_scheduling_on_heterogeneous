function T = PA(subtask_numb, types)
%%%% ����Han����ı������䷨(proportional allocation PA)��������������ͬ��types
%%%% types = [3 5 5]��ʾһ����3�����͵�types��ÿ��type�ĺ������ֱ�Ϊ3,5,5
    T = zeros(1,subtask_numb);
    V_int = round(subtask_numb * types ./ sum(types));  % �����ÿ��type��Ӧ�����������
    %%% ��������������ԭ����V_numb ��û��ƫ��
    diff = sum(V_int) - subtask_numb; %��������������ƫ��ֵ
    diff_v = subtask_numb * types ./ sum(types) - V_int; %������������仯��ֵ���������ֵ� - ����������
    temp_index_diff_v = 1: length(diff_v); %���㶨λ�Ͳ���
    while diff ~= 0 %��ʾ��ƫ��
        if diff > 0 %%��ʾ����������ԭ����������������ˣ���Ҫ���¼��١�diff_vԽС������Խ�ࣩ��ʾ֮ǰԽ��Ӧ�ý�һ�����ڼ���ȥ
            temp_index = find(min(diff_v(temp_index_diff_v)) == diff_v(temp_index_diff_v));
            temp_index = temp_index(1);
            change_index = temp_index_diff_v(temp_index);
            V_int(change_index) = V_int(change_index) - 1;
            temp_index_diff_v(temp_index) = [];
            diff = diff - 1;
        else
            temp_index = find(max(diff_v(temp_index_diff_v)) == diff_v(temp_index_diff_v));
            temp_index = temp_index(1);
            change_index = temp_index_diff_v(temp_index);
            V_int(change_index) = V_int(change_index) + 1;
            temp_index_diff_v(temp_index) = [];
            diff = diff + 1;
        end
        
    end
    %%%%%% ��ʱV_int �Ѿ�������ѡ�����ˣ���ʼ�����������Լ����Ӧ�Ĵ�����
    rest_V = 1:subtask_numb; %%%%%% ��ʾ��û�����subtasks
    for i = 1:length(types)-1 %%% ����type��˳�����
        while V_int(i) ~= 0 % �������0�����ʾ��type����Ҫ������������
           %�����rest_V�����ȡһ��������������ǰ��type i
           current_subtask_index = randi([1 length(rest_V)],1);
           current_subtask = rest_V(current_subtask_index);
           rest_V(current_subtask_index) = [];
           T(current_subtask) = i;
           V_int(i) = V_int(i) - 1;
        end
    end
    T(rest_V) = length(types);
end

















