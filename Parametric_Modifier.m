% 清空工作区
clear;
clc;

% 设置 Simulink 模型名称
modelName = 'IEEE33_line_fault'; % 替换为你的 Simulink 模型名称
open_system(modelName); % 打开模型

% 定义参数范围
P_min = 1.30e6; % P 的最小值
P_max = 1.70e6; % P 的最大值
QL_min = 0.40e6; % QL 的最小值
QL_max = 0.50e6; % QL 的最大值

% 循环修改 Node1 到 Node32 的参数
for i = 1:32
    % 生成随机参数值
    P = round((P_min + (P_max - P_min) * rand()), 2); % P 在 [1.30e6, 1.70e6] 范围内随机生成，保留两位小数
    QL = round((QL_min + (QL_max - QL_min) * rand()), 2); % QL 在 [0.40e6, 0.60e6] 范围内随机生成，保留两位小数
    
    % 构造模块名称
    nodeName = [modelName, '/Node', num2str(i)]; % 例如 'Your_Simulink_Model/Node1'
    
    % 修改模块参数
    set_param(nodeName, 'ActivePower', num2str(P)); % 设置 P 参数
    set_param(nodeName, 'InductivePower', num2str(QL)); % 设置 QL 参数
    
    % 打印修改信息
    fprintf('已修改 %s 的参数: P = %.2f, QL = %.2f\n', nodeName, P, QL);
end

% 保存模型
save_system(modelName);

% 关闭模型
close_system(modelName);

disp('参数修改完成，模型已保存。');