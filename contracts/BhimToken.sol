// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract BhimToken {
    mapping(address => uint) private s_balances;

    mapping(address => mapping(address => uint256)) private s_allowances;

    uint256 private s_totalSupply;

    string private i_name;
    string private i_symbol;

    constructor(string memory _name, string memory _symbol, uint256 _initialTokenSupply) {
        i_name = _name;
        i_symbol = _symbol;
        _mint(msg.sender, _initialTokenSupply);
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function name() public view returns (string memory) {
        return i_name;
    }

    function symbol() public view returns (string memory) {
        return i_symbol;
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return s_totalSupply;
    }

    function balanceOf(address account) external view returns (uint256) {
        return s_balances[account];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return s_allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _transfer(address _from, address _to, uint256 _amount) internal {
        require(_from != address(0), "ERC20: transfer from the zero address");
        require(_to != address(0), "ERC20: transfer to the zero address");

        uint256 fromBalance = s_balances[_from];
        require(fromBalance >= _amount, "ERC20: transfer amount exceeds balance");

        // To disbale underflow and overflow check as we have already did it ourselves
        unchecked {
            s_balances[_from] -= _amount;
            s_balances[_to] += _amount;
        }

        emit Transfer(_from, _to, _amount);
    }

    function _approve(address _owner, address _spender, uint256 _amount) internal {
        require(_owner != address(0), "ERC20: approve from the zero address");
        require(_spender != address(0), "ERC20: approve to the zero address");

        s_allowances[_owner][_spender] = _amount;
        emit Approval(_owner, _spender, _amount);
    }

    function _spendAllowance(address _owner, address _spender, uint256 _amount) internal {
        uint256 _currentAllowances = s_allowances[_owner][_spender];
        if (_currentAllowances != type(uint256).max) {
            require(_currentAllowances >= _amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(_owner, _spender, _currentAllowances - _amount);
            }
        }
    }

    function _mint(address _account, uint256 _amount) internal virtual {
        require(_account != address(0), "ERC20: mint to the zero address");

        s_totalSupply += _amount;

        unchecked {
            s_balances[_account] += _amount;
        }

        emit Transfer(address(0), _account, _amount);
    }
}
