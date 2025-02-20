% 清空工作区
clear;
clc;

% 设置仿真参数
sampleFrequency = 12000; % 采样频率（Hz）
simTime = 2/sampleFrequency; % 仿真时间2个周期（秒）
timeStep = 1/sampleFrequency; % 时间步长（秒）
numSamplesPerCycle = 34; % 每个周期的样本数
numCycles = simTime / (numSamplesPerCycle * timeStep); % 总周期数

% 初始化数据存储
data = zeros(ceil(numCycles), ceil(numSamplesPerCycle));

% 打开 Simulink 模型
modelName = 'Fault_Line'; % Simulink 模型文件名（不带扩展名）
open_system(modelName);

% 定义传输线模块的路径
LineBlock = [modelName '/ line1']; % 假设传输线模块名为 'Transmission Line'

% 循环仿真
for i = 1:numCycles
    % 动态修改传输线长度（例如从 10km 改为 5km）
    newLength = 5; % 新的传输线长度（km）
    set_param(LineBlock, 'Length', num2str(newLength));
    
    % 运行仿真
    simOut = sim(modelName, 'StopTime', num2str(simTime));
    
    % 提取数据（假设输出信号名为 'voltage_data'）
    voltageData = simOut.logsout{1}.Values.Data; % 从仿真输出中提取电压数据
    data(i, :) = voltageData(1:numSamplesPerCycle); % 提取一个周期的数据
end

% 保存数据
save('fault_data.mat', 'data');

% 关闭 Simulink 模型
close_system(modelName, 0);

disp('仿真完成，数据已保存为 fault_data.mat');