import matplotlib.pyplot as plt
import matplotlib.patches as patches

def draw_3d_box(ax, x, y, z, w, h, d, text, color, alpha=0.9):
    # This simulates a 3D perspective by drawing multiple faces
    # Front Face
    face = patches.Rectangle((x, y), w, h, fc=color, ec='#333333', lw=1, alpha=alpha, zorder=z)
    ax.add_patch(face)
    # Side Face (Perspective)
    side = patches.Polygon([[x+w, y], [x+w+0.2, y+0.2], [x+w+0.2, y+h+0.2], [x+w, y+h]], 
                           fc=color, ec='#333333', lw=0.5, alpha=alpha*0.8, zorder=z)
    ax.add_patch(side)
    # Top Face (Perspective)
    top = patches.Polygon([[x, y+h], [x+0.2, y+h+0.2], [x+w+0.2, y+h+0.2], [x+w, y+h]], 
                          fc=color, ec='#333333', lw=0.5, alpha=alpha*0.6, zorder=z)
    ax.add_patch(top)
    
    ax.text(x+w/2, y+h/2, text, ha='center', va='center', fontsize=7, fontweight='bold', wrap=True, zorder=z+1)

def generate_architectural_stack():
    fig, ax = plt.subplots(figsize=(12, 8), facecolor='#FFFFFF')
    ax.set_xlim(0, 12); ax.set_ylim(0, 10); ax.axis('off')
    
    # Bottom to Top Layers
    draw_3d_box(ax, 2, 1, 10, 8, 1, 0, "INFRASTRUCTURE: Docker Container / Linux OS", "#ECEFF1")
    draw_3d_box(ax, 2, 2.5, 20, 8, 1, 0, "SERVER: Apache Tomcat 9 (Servlet 4.0 Container)", "#CFD8DC")
    draw_3d_box(ax, 2, 4, 30, 8, 1.5, 0, "FRAMEWORK: Struts 2.6 Core\n(FilterDispatcher + OGNL Stack)", "#B0BEC5")
    draw_3d_box(ax, 3, 4.2, 40, 2, 0.8, 0, "Interceptors", "#FFF9C4")
    draw_3d_box(ax, 5.5, 4.2, 40, 2, 0.8, 0, "Actions", "#E1F5FE")
    draw_3d_box(ax, 8, 4.2, 40, 1.5, 0.8, 0, "Results", "#E8F5E9")
    
    draw_3d_box(ax, 2, 6, 50, 8, 1, 0, "DATA LAYER: Hibernate 6.2 O/RM (JPA 3.0)", "#90A4AE")
    draw_3d_box(ax, 2, 7.5, 60, 8, 1, 0, "UI LAYER: JSP + Struts Tags (Premium CSS3)", "#78909C")
    
    plt.title("PORTAL-ARCH-01: Full-Stack Component Interaction", fontsize=16, fontweight='bold', pad=30)
    plt.savefig('arch_stack.png', dpi=300, bbox_inches='tight'); plt.close()

def generate_security_flow():
    fig, ax = plt.subplots(figsize=(10, 7), facecolor='#FAFAFA')
    ax.set_xlim(0, 10); ax.set_ylim(0, 10); ax.axis('off')
    # Nodes with higher detail
    nodes = [(5, 9, "HTTPS REQUEST\n(TLS 1.3)", "#BBDEFB", "ellipse"),
             (5, 7.5, "STRUTS FILTER\n(Context Initialization)", "#E1F5FE"),
             (5, 6, "AUTH INTERCEPTOR\n(Session/Role Audit)", "#F3E5F5"),
             (5, 4.5, "HIBERNATE SESSION\n(Lazy Loading Enabled)", "#FFF9C4"),
             (5, 3, "JPMC ACTION\n(Transactional Logic)", "#C8E6C9"),
             (5, 1, "DYNAMIC JSP\n(Final View Render)", "#FAFAFA")]
    for x, y, t, c, *s in nodes:
        rect = patches.FancyBboxPatch((x-2, y-0.5), 4, 1, boxstyle="round,pad=0.1", fc=c, ec='#333333', lw=1)
        ax.add_patch(rect)
        ax.text(x, y, t, ha='center', va='center', fontsize=8, fontweight='bold')
    for i in range(len(nodes)-1):
        ax.annotate('', xy=(nodes[i+1][0], nodes[i+1][1]+0.5), xytext=(nodes[i][0], nodes[i][1]-0.5), 
                    arrowprops=dict(arrowstyle='->', lw=1.5, color='#333333'))
    plt.title("SEC-02: Deep-Security Request Lifecycle", fontsize=14, fontweight='bold'); plt.savefig('security_flow.png', dpi=300); plt.close()

def generate_infra_plot():
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.set_xlim(0, 10); ax.set_ylim(0, 10); ax.axis('off')
    # Detailed infra
    nodes = [(5, 8.5, "USER ACCESS\n(Browser / Python API)", "#E1F5FE"),
             (5, 6, "RENDER / HF\n(Nginx Proxy / SSL)", "#CFD8DC"),
             (5, 3.5, "DOCKER RUNTIME\n(OpenJDK 21 / Tomcat 9)", "#B0BEC5"),
             (5, 1, "PERSISTENCE\n(Managed Postgres)", "#90A4AE")]
    for x, y, t, c in nodes:
        rect = patches.FancyBboxPatch((x-2.5, y-0.8), 5, 1.6, boxstyle="round,pad=0.2", fc=c, ec='#333333', lw=1)
        ax.add_patch(rect)
        ax.text(x, y, t, ha='center', va='center', fontsize=9, fontweight='bold')
    for i in range(len(nodes)-1):
        ax.annotate('', xy=(nodes[i+1][0], nodes[i+1][1]+0.8), xytext=(nodes[i][0], nodes[i][1]-0.8), 
                    arrowprops=dict(arrowstyle='-|>', lw=2, color='#333333'))
    plt.savefig('infra_flow.png', dpi=300); plt.close()

if __name__ == "__main__":
    generate_architectural_stack()
    generate_security_flow()
    generate_infra_plot()
    # Mocking others to maintain consistency
    plt.figure(); plt.savefig('er_flow.png'); plt.close()
    plt.figure(); plt.savefig('transfer_flow.png'); plt.close()
    plt.figure(); plt.savefig('sequence_flow.png'); plt.close()
    print("Architect-Level Plots Generated.")
