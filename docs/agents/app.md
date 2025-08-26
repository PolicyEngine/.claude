# App Development Agents

Specialized agents for PolicyEngine React application development.

## App Reviewer

**File**: `.claude/agents/app/app-reviewer.md`

A specialized reviewer for React application code, focusing on component quality, performance, and user experience.

### Review Focus Areas

```{mermaid}
graph TD
    A[App Review] --> B[React Patterns]
    A --> C[Performance]
    A --> D[Accessibility]
    A --> E[User Experience]
    
    B --> B1[Functional Components]
    B --> B2[Hook Usage]
    B --> B3[State Management]
    B --> B4[Component Design]
    
    C --> C1[Memoization]
    C --> C2[Lazy Loading]
    C --> C3[Bundle Size]
    C --> C4[Render Optimization]
    
    D --> D1[Semantic HTML]
    D --> D2[ARIA Labels]
    D --> D3[Keyboard Nav]
    D --> D4[Screen Readers]
    
    E --> E1[Loading States]
    E --> E2[Error Handling]
    E --> E3[Responsive Design]
    E --> E4[Form Validation]
    
    style A fill:#f5f5f5
    style B fill:#e1f5fe
    style C fill:#fff3e0
    style D fill:#e8f5e9
    style E fill:#f3e5f5
```

### React Best Practices

✅ **Functional Components Only**
```jsx
// Good: Functional component with hooks
function HouseholdInput({ household, onChange }) {
  const [income, setIncome] = useState(household.income);
  
  useEffect(() => {
    onChange({ ...household, income });
  }, [income]);
  
  return <input value={income} onChange={e => setIncome(e.target.value)} />;
}

// Bad: Class component
class HouseholdInput extends React.Component {
  // Never use class components
}
```

✅ **Proper Hook Usage**
```jsx
// Good: Complete dependency array
useEffect(() => {
  fetchData(userId, year);
}, [userId, year]);  // All dependencies listed

// Bad: Missing dependencies
useEffect(() => {
  fetchData(userId, year);
}, []);  // ESLint will warn!
```

✅ **State Management Pattern**
```jsx
// Good: Lift state up
function Parent() {
  const [data, setData] = useState(null);
  
  return (
    <>
      <ChildA data={data} />
      <ChildB onUpdate={setData} />
    </>
  );
}

// No global state management - use prop drilling or context sparingly
```

### Performance Optimization

✅ **Memoization**
```jsx
// Good: Memoize expensive calculations
const expensiveValue = useMemo(() => {
  return calculateComplexValue(data);
}, [data]);

// Good: Memoize callbacks
const handleClick = useCallback(() => {
  doSomething(id);
}, [id]);

// Good: Memoize components
const MemoizedChart = React.memo(Chart, (prev, next) => {
  return prev.data === next.data;
});
```

✅ **Lazy Loading**
```jsx
// Good: Lazy load heavy components
const HeavyChart = lazy(() => import('./HeavyChart'));

function Dashboard() {
  return (
    <Suspense fallback={<Loading />}>
      <HeavyChart />
    </Suspense>
  );
}
```

✅ **Plotly Optimization**
```jsx
// Good: Optimize Plotly renders
const chartConfig = useMemo(() => ({
  responsive: true,
  displayModeBar: false
}), []);

const chartData = useMemo(() => 
  formatChartData(rawData), 
  [rawData]
);

return <Plot data={chartData} config={chartConfig} />;
```

### Accessibility Requirements

✅ **Semantic HTML**
```jsx
// Good: Semantic elements
<nav aria-label="Main navigation">
  <ul>
    <li><a href="/home">Home</a></li>
  </ul>
</nav>

// Bad: Div soup
<div onClick={handleClick}>Click me</div>  // Use <button>
```

✅ **ARIA Labels**
```jsx
// Good: Descriptive labels
<button 
  aria-label="Calculate household benefits"
  aria-busy={loading}
  aria-disabled={!valid}
>
  Calculate
</button>

<div role="alert" aria-live="polite">
  {error && <p>{error}</p>}
</div>
```

✅ **Keyboard Navigation**
```jsx
// Good: Keyboard support
function Modal({ isOpen, onClose }) {
  useEffect(() => {
    function handleEscape(e) {
      if (e.key === 'Escape') onClose();
    }
    if (isOpen) {
      document.addEventListener('keydown', handleEscape);
      return () => document.removeEventListener('keydown', handleEscape);
    }
  }, [isOpen, onClose]);
}
```

### User Experience

✅ **Loading States**
```jsx
// Good: Show loading feedback
function DataDisplay({ url }) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  if (loading) return <Skeleton />;
  if (error) return <ErrorMessage error={error} />;
  if (!data) return <EmptyState />;
  
  return <DataView data={data} />;
}
```

✅ **Form Validation**
```jsx
// Good: Real-time validation
function IncomeInput({ value, onChange }) {
  const [error, setError] = useState(null);
  
  const validate = (val) => {
    if (val < 0) setError("Income cannot be negative");
    else if (val > 10000000) setError("Please enter a realistic income");
    else setError(null);
  };
  
  return (
    <>
      <input 
        type="number"
        value={value}
        onChange={e => {
          const val = Number(e.target.value);
          validate(val);
          onChange(val);
        }}
        aria-invalid={!!error}
        aria-describedby={error ? "income-error" : undefined}
      />
      {error && <span id="income-error" role="alert">{error}</span>}
    </>
  );
}
```

### Code Quality Standards

✅ **ESLint Compliance**
```bash
# Must pass with no warnings
npm run lint -- --max-warnings=0

# Auto-fix issues
npm run lint -- --fix
```

✅ **Prettier Formatting**
```bash
# Format all files
npx prettier --write .

# Check formatting
npx prettier --check .
```

✅ **Component Size**
```jsx
// Good: Small, focused components (<150 lines)
function HouseholdSection({ household }) {
  // Single responsibility
  // Clear props interface  
  // Reusable
}

// Bad: Monolithic components (>150 lines)
function EntireHouseholdPage() {
  // Too much in one component
}
```

### Testing Requirements

✅ **User Interaction Tests**
```jsx
import { render, screen, fireEvent } from '@testing-library/react';

test('calculates on button click', async () => {
  render(<Calculator />);
  
  const input = screen.getByLabelText(/income/i);
  fireEvent.change(input, { target: { value: '50000' } });
  
  const button = screen.getByRole('button', { name: /calculate/i });
  fireEvent.click(button);
  
  await screen.findByText(/your benefit: \$1,200/i);
});
```

✅ **Accessibility Tests**
```jsx
import { axe } from 'jest-axe';

test('has no accessibility violations', async () => {
  const { container } = render(<App />);
  const results = await axe(container);
  expect(results).toHaveNoViolations();
});
```

## Common Issues to Check

### 1. Missing Loading States
- Every async operation needs loading feedback
- Use skeletons or spinners appropriately
- Disable interactions during loading

### 2. Poor Error Handling
- Catch and display user-friendly errors
- Provide recovery actions
- Log errors for debugging

### 3. Unoptimized Renders
- Check for unnecessary re-renders
- Use React DevTools Profiler
- Memoize expensive operations

### 4. Accessibility Violations
- Run axe DevTools
- Test with keyboard only
- Test with screen reader

### 5. Mobile Responsiveness
- Test on various screen sizes
- Ensure touch-friendly interactions
- Optimize for mobile performance

## Integration with API

```jsx
// Good: Proper API integration
function useHouseholdData(id) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    let cancelled = false;
    
    async function fetchData() {
      try {
        setLoading(true);
        const response = await fetch(`/api/households/${id}`);
        if (!response.ok) throw new Error(response.statusText);
        const result = await response.json();
        if (!cancelled) setData(result);
      } catch (err) {
        if (!cancelled) setError(err.message);
      } finally {
        if (!cancelled) setLoading(false);
      }
    }
    
    fetchData();
    return () => { cancelled = true; };
  }, [id]);
  
  return { data, loading, error };
}
```

## Review Process

1. **Lint First**: Ensure no ESLint warnings
2. **Component Review**: Check patterns and size
3. **Performance**: Look for optimization opportunities
4. **Accessibility**: Verify WCAG compliance
5. **User Experience**: Test interactions
6. **Testing**: Ensure comprehensive coverage