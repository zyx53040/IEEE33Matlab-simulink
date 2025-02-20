% 清空工作区
clear;
clc;

% 设置 Simulink 模型名称
modelName = 'IEEE33_line_fault'; % 替换为你的 Simulink 模型名称
open_system(modelName); % 打开模型

% 定义模块名称
nodeName = [modelName, '/Node1']; % 例如 'Your_Simulink_Model/Node1'

% 获取模块的所有参数
moduleParams = get_param(nodeName, 'ObjectParameters');

% 输出参数名称
fprintf('模块 %s 的所有参数名称：\n', nodeName);
paramNames = fieldnames(moduleParams); % 获取所有参数的字段名
for i = 1:length(paramNames)
    fprintf('%s\n', paramNames{i});
end

% 关闭模型
close_system(modelName);

disp('参数名称输出完成。');