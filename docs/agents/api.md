# API Development Agents

Specialized agents for PolicyEngine API development.

## API Reviewer

**File**: `.claude/agents/api/api-reviewer.md`

A specialized reviewer for Flask-based API code, focusing on performance, security, and REST best practices.

### Review Focus Areas

```{mermaid}
graph TD
    A[API Review] --> B[Security]
    A --> C[Performance]
    A --> D[Code Quality]
    A --> E[Testing]
    
    B --> B1[SQL Injection]
    B --> B2[Authentication]
    B --> B3[CORS]
    B --> B4[Rate Limiting]
    
    C --> C1[Query Optimization]
    C --> C2[Caching Strategy]
    C --> C3[Pagination]
    C --> C4[Async Jobs]
    
    D --> D1[REST Conventions]
    D --> D2[Error Handling]
    D --> D3[Status Codes]
    D --> D4[Documentation]
    
    E --> E1[Endpoint Tests]
    E --> E2[Edge Cases]
    E --> E3[Mock Usage]
    E --> E4[Error Tests]
    
    style A fill:#f5f5f5
    style B fill:#ffebee
    style C fill:#fff3e0
    style D fill:#e1f5fe
    style E fill:#e8f5e9
```

### Security Checklist

✅ **Input Validation**
```python
# Good: Parameterized queries
cursor.execute(
    "SELECT * FROM users WHERE id = ?",
    (user_id,)
)

# Bad: String concatenation
cursor.execute(
    f"SELECT * FROM users WHERE id = {user_id}"
)
```

✅ **Authentication & Authorization**
```python
@require_auth
@require_role("admin")
def admin_endpoint():
    return {"status": "success"}
```

✅ **CORS Configuration**
```python
CORS(app, origins=[
    "https://policyengine.org",
    "http://localhost:3000"  # Dev only
])
```

### Performance Best Practices

✅ **Database Optimization**
```python
# Good: Eager loading relationships
results = (
    db.session.query(Household)
    .options(joinedload(Household.people))
    .filter_by(country="us")
    .all()
)

# Bad: N+1 queries
households = Household.query.filter_by(country="us").all()
for h in households:
    people = h.people  # Triggers query each iteration
```

✅ **Redis Caching**
```python
@cache.memoize(timeout=3600)
def calculate_impact(household_id, reform_id):
    # Expensive calculation cached for 1 hour
    return perform_calculation()
```

✅ **Background Jobs**
```python
from rq import Queue

def handle_large_request(data):
    job = queue.enqueue(
        process_calculation,
        data,
        timeout=300
    )
    return {"job_id": job.id}
```

### REST API Standards

✅ **Proper Status Codes**
```python
# Good: Semantic status codes
@app.route("/households/<id>", methods=["GET"])
def get_household(id):
    household = Household.query.get(id)
    if not household:
        return {"error": "Not found"}, 404
    return household.to_dict(), 200

# Bad: Always returning 200
return {"error": "Not found"}, 200  # Wrong!
```

✅ **RESTful Routes**
```
GET    /households          # List
POST   /households          # Create
GET    /households/:id      # Read
PUT    /households/:id      # Update
DELETE /households/:id      # Delete
```

### Error Handling

✅ **Consistent Error Format**
```python
def error_response(message, status_code, details=None):
    response = {
        "error": message,
        "status": status_code
    }
    if details:
        response["details"] = details
    return jsonify(response), status_code

# Usage
return error_response(
    "Invalid household data",
    400,
    {"missing_fields": ["income", "size"]}
)
```

### Testing Requirements

✅ **Comprehensive Endpoint Tests**
```python
def test_calculate_endpoint():
    # Arrange
    household_data = {...}
    
    # Act
    response = client.post(
        "/calculate",
        json=household_data
    )
    
    # Assert
    assert response.status_code == 200
    assert "net_income" in response.json
```

✅ **Error Condition Testing**
```python
def test_invalid_data_returns_400():
    response = client.post(
        "/calculate",
        json={"invalid": "data"}
    )
    assert response.status_code == 400
    assert "error" in response.json
```

## Common Issues to Check

### 1. SQL Injection Vulnerabilities
- Never use string formatting for queries
- Always use parameterized statements
- Validate and sanitize all inputs

### 2. Missing Rate Limiting
- Implement rate limiting for public endpoints
- Use Redis for distributed rate limiting
- Return 429 Too Many Requests appropriately

### 3. Poor Error Messages
- Don't expose internal details in production
- Provide helpful messages for developers
- Log full errors server-side

### 4. Unoptimized Queries
- Use query profiling to find slow queries
- Add appropriate database indexes
- Implement pagination for large datasets

### 5. Missing API Documentation
- Document all endpoints
- Include request/response schemas
- Provide example calls

## Integration with Country Models

The API often calls country model calculations:

```python
from policyengine_us import Simulation

def calculate_household(household_data, reform=None):
    # Create simulation
    sim = Simulation(
        situation=household_data,
        reform=reform
    )
    
    # Calculate variables
    net_income = sim.calculate("household_net_income")
    
    # Cache results
    cache.set(cache_key, net_income)
    
    return net_income
```

## Review Process

1. **Security First**: Check for vulnerabilities
2. **Performance**: Look for optimization opportunities
3. **Standards**: Ensure REST conventions
4. **Testing**: Verify comprehensive tests
5. **Documentation**: Check API docs updated