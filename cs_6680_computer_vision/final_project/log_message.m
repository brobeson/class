function log_message(msg_type, msg)
    % log_message  Write a message to the command window with a time stamp
    %   log_message(msg)
    %   log_message(msg_type, msg)
    %
    %   msg         The message to display. This must be a string.
    %   msg_type    The type of message. This can be 'info' or 'warning'. If
    %               omitted, the default value is 'info'.
    %
    %   This function determine the time for the log message and writes the
    %   message in the form:
    %       msg_type: yyyy-mm-dd hh:mm:ss  msg
    %
    %   Note that if msg_type is 'warning', no backtrace is displpayed. If
    %   msg_type is not 'info' or 'warning', the msg is printed as info.
    
    % get the current date & time, and write it to a string
    c = clock;
    clock_str = sprintf('%u-%02u-%02u %02u:%02u:%02.0f', c(1), c(2), c(3), c(4), c(5), c(6));

    % if the user only supplied one argumet, it's the message, not the message
    % type
    if (nargin == 1)
        msg = msg_type;
        msg_type = 'info';
    end

    % write the message as appropriate
    if ~strcmp(msg_type, 'warning')
        fprintf(1, 'Info:    %s  %s\n', clock_str, msg);
    else
        warning off backtrace
        warning('%s  %s', clock_str, msg);
        warning on backtrace
    end
end
