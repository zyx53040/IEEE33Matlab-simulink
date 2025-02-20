% 清空工作区
clear;
clc;

% 设置仿真参数
% 设置仿真参数
simTime = 0.04; % 仿真时间 0.04 秒
numSamples = 100; % 采集 100 个样本数据
sampleFrequency = numSamples / simTime; % 计算采样频率（Hz）
timeStep = 1 / sampleFrequency; % 时间步长（秒）
% 打开 Simulink 模型
modelName = 'Three_phase_line_fault'; % Simulink 模型文件名（不带扩展名）
open_system(modelName);

% 定义传输线模块的路径
Line1Block = [modelName '/line1']; % line1 模块路径
Line2Block = [modelName '/line2']; % line2 模块路径

% 循环仿真，修改 line1 和 line2 的长度
for i = 0.1:0.1:0.9
    % 设置 line1 的长度从 0.1 到 0.9
    line1Length = i; % line1 的长度
    line2Length = 1 - line1Length; % line2 的长度，确保总和为 1
    
    % 动态修改传输线长度
    set_param(Line1Block, 'Length', num2str(line1Length));
    set_param(Line2Block, 'Length', num2str(line2Length));
    
    % 运行仿真
    simOut = sim(modelName, 'StopTime', num2str(simTime));
    
    % 提取 Vabc 和 Iabc 数据
    Vabc = simOut.Vabc1.Data; % 提取电压数据
    Iabc = simOut.Iabc1.Data; % 提取电流数据
    
    % 生成变量名
    line1LengthStr = sprintf('%.1f', line1Length); % 将长度转换为字符串
    line1LengthStr = strrep(line1LengthStr, '.', ''); % 去掉小数点
    VabcName = ['Vabc', line1LengthStr]; % 生成 Vabc 变量名
    IabcName = ['Iabc', line1LengthStr]; % 生成 Iabc 变量名
    
    % 将数据输出到工作区
    assignin('base', VabcName, Vabc); % 将 Vabc 数据输出到工作区
    assignin('base', IabcName, Iabc); % 将 Iabc 数据输出到工作区
    
    % 打印当前仿真进度
    fprintf('仿真进度: line1 = %.1f km, line2 = %.1f km\n', line1Length, line2Length);
end

% 关闭 Simulink 模型
close_system(modelName, 0);

disp('仿真完成，数据已输出到工作区');