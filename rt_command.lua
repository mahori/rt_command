local request_table = {}
request_table.url = arg[1]
request_table.method = 'GET'

local response_table = rt.httprequest(request_table)

if not response_table.rtn1 then
  os.exit(-1)
end

if response_table.code ~= 200 then
  os.exit(response_table.code)
end

local success_lines = {}
local current_line = 0

for line in each(response_table.body:split(/\n/)) do
  if (string.len(line) > 0) then
    current_line = current_line + 1

    local rtn, str = rt.command(line, 'off')
    if rtn then
      table.insert(success_lines, current_line)
    end
  end
end

local script_name = debug.getinfo(1).short_src
rt.syslog('debug', script_name .. ' ' .. 'number of lines: ' .. current_line)
rt.syslog('debug', script_name .. ' ' .. 'success lines: ' .. table.concat(success_lines, ' '))

os.exit(0)
