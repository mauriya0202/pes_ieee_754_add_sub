module pes_ieee_754_add_sub (
	a1,
	b1,
	c,
	cntl1,
	clk
);
	input wire [31:0] a1;
	input wire [31:0] b1;
	output reg [31:0] c;
	input wire cntl1;
	input wire clk;
	reg [31:0] temp;
	reg [7:0] ea;
	reg [7:0] eb;
	reg [7:0] bias;
	reg [7:0] e;
	reg [22:0] ma;
	reg [22:0] mb;
	reg [22:0] m_f;
	reg [27:0] ma_temp;
	reg [27:0] mb_temp;
	reg [27:0] m_add;
	reg [27:0] m_temp;
	wire [27:0] m_temp1;
	reg [27:0] msub;
	reg [24:0] m1;
	reg cntl;
	reg g;
	reg r;
	reg s0;
	reg s1;
	reg s;
	reg p;
	reg s3;
	reg [31:0] a;
	reg [31:0] a2;
	reg [31:0] b;
	reg [31:0] b2;
	reg signed [31:0] l;
	always @(posedge clk) begin
		c[31] <= s3;
		c[22:0] <= m_f;
		c[30:23] <= e;
		a2 <= a1;
		b2 <= b1;
	end
	always @(*) begin : sv2v_autoblock_1
		reg [0:1] _sv2v_jump;
		_sv2v_jump = 2'b00;
		a = a2;
		b = b2;
		cntl = cntl1;
		if (cntl == 1)
			b[31] = ~b[31];
		else
			b[31] = b[31];
		if (a[30:23] < b[30:23]) begin
			temp = a;
			a = b;
			b = temp;
		end
		else if (a[30:23] == b[30:23]) begin
			if (a[22:0] < b[22:0]) begin
				temp = a;
				a = b;
				b = temp;
			end
		end
		else begin
			a = a;
			b = b;
		end
		ea = a[30:23];
		eb = b[30:23];
		ma = a[22:0];
		mb = b[22:0];
		bias = ea - eb;
		s3 = a[31];
		mb_temp[25:3] = mb;
		ma_temp[25:3] = ma;
		mb_temp[26] = 1;
		ma_temp[26] = 1;
		mb_temp[27] = 0;
		ma_temp[27] = 0;
		ma_temp[2:0] = 0;
		mb_temp[2:0] = 0;
		mb_temp = mb_temp >> bias;
		if (a[31] == b[31]) begin
			m_add = ma_temp + mb_temp;
			e = (m_add[27] ? ea + 1 : ea);
			m_temp[25:0] = (m_add[27] ? m_add[26:1] : m_add[25:0]);
			m_temp[26] = 1;
			m_temp[27] = 0;
			g = m_temp[3];
			r = m_temp[2];
			s0 = m_temp[0];
			s1 = m_temp[1];
			s = s0 | s1;
			p = r & ((~g & s) | g);
			if (p)
				m1 = m_temp[27:3] + 1;
			else
				m1 = m_temp[27:3];
			if (ea == eb)
				m_f = (m_add[27] ? m1[22:0] : m1[23:1]);
			else
				m_f = (m1[24] ? m1[23:1] : m1[22:0]);
			e = (m1[24] ? e + 1 : e);
		end
		else if (a[31] != b[31]) begin
			e = ea;
			if (bias == 2'b00)
				mb_temp[27:3] = ~mb_temp[27:3] + 1;
			else if (bias == 2'b01)
				mb_temp[27:2] = ~mb_temp[27:2] + 1;
			else if (bias == 2'b10)
				mb_temp[27:1] = ~mb_temp[27:1] + 1;
			else if (bias == 2'b11)
				mb_temp[27:0] = ~mb_temp[27:0] + 1;
			else
				mb_temp = ~mb_temp;
			msub = ma_temp + mb_temp;
			g = msub[3];
			r = msub[2];
			s0 = msub[0];
			s1 = msub[1];
			s = s0 | s1;
			p = r & ((~g & s) | g);
			if (p)
				m1 = msub[26:3] + 1;
			else
				m1 = msub[26:3];
			begin : sv2v_autoblock_2
				reg signed [31:0] _sv2v_value_on_break;
				for (l = 0; l < 25; l = l + 1)
					if (_sv2v_jump < 2'b10) begin
						_sv2v_jump = 2'b00;
						if (~m1[23]) begin
							if (m1 != 0) begin
								m1 = m1 << 1;
								e = e - 1;
								if (m1[23])
									_sv2v_jump = 2'b10;
							end
							else
								m1 = m1;
						end
						_sv2v_value_on_break = l;
					end
				if (!(_sv2v_jump < 2'b10))
					l = _sv2v_value_on_break;
				if (_sv2v_jump != 2'b11)
					_sv2v_jump = 2'b00;
			end
			if (_sv2v_jump == 2'b00)
				m_f = m1[22:0];
		end
	end
endmodule
