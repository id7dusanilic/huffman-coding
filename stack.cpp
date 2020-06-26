#include <stack>

struct chter {
	char c;
	unsigned short cnt;
};

struct node {
	struct chter;
	unsigned short left, right;
};

int main() {
	const unsigned N = 6;
	struct chter a[N] = {{'a', 5}, {'b', 9}, {'c', 12}, {'d', 13}, {'e', 16}, {'f', 45}};
	std::stack<int> st;
	int b[2*N - 1] = {0};

	int ia = 0, ib = 0;

	b[ib++] = a[ia++].cnt;
	b[ib++] = a[ia++].cnt;

	st.push(a[0].cnt + a[1].cnt);
	b[ib++] = st.top();

	while(ia < N) {
		int tmp = 0;
		if(st.size() == 2) {
			tmp = st.top();
			st.pop();
			if(a[ia].cnt < tmp && st.top() < tmp) { 
// the largest element goes to the bottom of the stack
				int swap = st.top();
				st.pop();
				st.push(tmp);
				st.push(swap);
				st.push(a[ia++].cnt);
				b[ib++] = st.top();
				tmp = st.top();
				st.pop();
			}
			tmp += st.top();
			st.pop();
			st.push(tmp);
			b[ib++] = tmp;
		}
		else if (ia < N -1) {
			if(a[ia].cnt < st.top() && a[ia+1].cnt < st.top()) {
				b[ib++] = a[ia++].cnt;
				b[ib++] = a[ia++].cnt;

				st.push(b[ib-2] + b[ib-1]);
				b[ib++] = st.top();
			}
			else {
				tmp = st.top();
				st.pop();
				b[ib++] = a[ia].cnt;
				st.push(tmp + a[ia++].cnt);
				b[ib++] = st.top();
			}
		}
		else {
			b[ib++] = a[ia].cnt;
			tmp = st.top();
			st.pop();
			b[ib++] = tmp + a[ia++].cnt;
		}
	}
}
